import 'dart:convert';

import 'package:drift/drift.dart';

import '../drift/app_database.dart';

/// Thrown when the backup payload is structurally invalid (not the original
/// app's export shape). Raised *before* any data is touched, so the existing
/// database is left untouched on a bad file.
class BackupFormatException implements Exception {
  BackupFormatException(this.message);

  final String message;

  @override
  String toString() => 'BackupFormatException: $message';
}

/// Summary of a completed import: how many rows landed in each table plus any
/// non-fatal problems encountered (unknown tables, columns dropped because they
/// no longer exist in the v2 schema).
class BackupImportResult {
  BackupImportResult({required this.rowsByTable, required this.warnings});

  final Map<String, int> rowsByTable;
  final List<String> warnings;

  int get totalRows => rowsByTable.values.fold(0, (sum, n) => sum + n);
}

/// Backup / restore / wipe operations against the app database, all expressed
/// in the original Time Tracker Pro JSON backup shape so files round-trip
/// between the two apps:
///
/// ```json
/// {
///   "export_format_version": 2,
///   "database_version": 23,
///   "tables": { "clients": [ { "id": 1, ... } ], "projects": [ ... ], ... }
/// }
/// ```
///
/// `export_format_version` is 2 for files this app writes: money columns are
/// integer cents. Version 1 (the original app) carries money as dollars and is
/// upconverted ×100 on import. Each row carries its original primary key, so
/// foreign-key relationships are preserved verbatim. Import is a **destructive replace**: every table is
/// wiped and repopulated inside a single transaction, so any failure rolls the
/// whole database back to its pre-import state.
class BackupRepository {
  BackupRepository(this._db);

  final AppDatabase _db;

  /// Export format version. Bumped to 2 when money columns moved from dollars
  /// (real) to integer cents. v2 files carry money as cents; v1 files (the
  /// original app) carry money as dollars and are upconverted on import.
  static const int _exportFormatVersion = 2;

  /// Money columns (per table, in DB snake_case) that are stored as integer
  /// cents in v2. On import of a v1 (dollars) backup these are multiplied by
  /// 100. Keep in sync with the `IntColumn` money fields in the table defs.
  static const Map<String, List<String>> _moneyColumnsByTable = {
    'invoices': [
      'labour_subtotal',
      'materials_subtotal',
      'materials_pickup_cost',
      'other_costs',
      'discount_amount',
      'tax1_amount',
      'tax2_amount',
      'subtotal',
      'total_amount',
    ],
    'invoice_payments': ['amount'],
    'materials': ['cost'],
    'worker_payments': ['amount'],
    'projects': ['billed_hourly_rate', 'project_price'],
    'employees': ['hourly_rate'],
    'roles': ['standard_rate'],
    'settings': ['company_hourly_rate'],
    'time_entries': ['hourly_rate'],
  };

  /// Inline payment columns carried on `invoices` rows by v23/legacy backups.
  /// They no longer exist on the v2 `invoices` table; on import they are
  /// migrated into `invoice_payments` rather than dropped.
  static const Set<String> _legacyInvoicePaymentColumns = {
    'is_paid',
    'amount_paid',
    'payment_date',
    'payment_method',
    'payment_reference',
    'payment_notes',
  };

  /// The schema content matches the original v23, regardless of this app's own
  /// drift `schemaVersion`. Emitted for round-trip compatibility.
  static const int _databaseVersion = 23;

  /// Tables in child-before-parent order. Used directly for the wipe (delete
  /// children first) and reversed for inserts (parents first) so foreign keys
  /// are always satisfiable even if FK enforcement is on.
  static const List<String> _childToParentOrder = [
    'time_entries',
    'materials',
    'worker_payments',
    'invoice_payments',
    'invoices',
    'employees',
    'projects',
    'cost_codes',
    'expense_categories',
    'roles',
    'clients',
    'company_settings',
    'settings',
  ];

  // ---- Export --------------------------------------------------------------

  /// Serialises every table to the original app's backup JSON shape. Parents
  /// are emitted before children for readability; order is irrelevant to the
  /// importer since rows keep their primary keys.
  Future<String> exportToJsonString() async {
    final tables = <String, List<Map<String, dynamic>>>{};
    for (final name in _childToParentOrder.reversed) {
      final rows = await _db.customSelect('SELECT * FROM $name').get();
      tables[name] = rows.map((r) => Map<String, dynamic>.from(r.data)).toList();
    }
    return jsonEncode({
      'export_format_version': _exportFormatVersion,
      'database_version': _databaseVersion,
      'tables': tables,
    });
  }

  // ---- Clear ---------------------------------------------------------------

  /// Wipes every table and re-seeds the app defaults, leaving the database in
  /// the same clean state as a fresh install (mirrors the original
  /// `deleteAllData`). Re-seeding keeps the singleton settings rows and the
  /// internal "Company Expenses" client/project so the app stays usable.
  Future<void> clearAllData() async {
    await _db.customStatement('PRAGMA foreign_keys = OFF');
    try {
      await _db.transaction(() async {
        for (final name in _childToParentOrder) {
          await _db.customStatement('DELETE FROM $name');
        }
      });
    } finally {
      await _db.customStatement('PRAGMA foreign_keys = ON');
    }
    await _db.seedDefaults();
  }

  // ---- Import --------------------------------------------------------------

  Future<BackupImportResult> importFromJsonString(String jsonString) async {
    final Map<String, dynamic> payload;
    try {
      payload = jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw BackupFormatException('File is not valid JSON: $e');
    }

    final tablesRaw = payload['tables'];
    if (tablesRaw is! Map<String, dynamic>) {
      throw BackupFormatException(
        "Missing top-level 'tables' object — this does not look like a Time "
        'Tracker Pro backup.',
      );
    }
    final tables = tablesRaw;

    // Money columns moved to integer cents in export_format_version 2. Files at
    // version 1 (or missing the field — original-app backups) carry money as
    // dollars and must be multiplied by 100 on the way in. A missing version is
    // treated as legacy v1 to stay safe with older files.
    final formatVersion =
        (payload['export_format_version'] as num?)?.toInt() ?? 1;
    final isLegacyDollars = formatVersion < 2;

    final rowsByTable = <String, int>{};
    final warnings = <String>[];

    // `cost_codes.category` is a v2-only column: v1 backups don't carry it, so
    // the destructive replace below would blank it on every code. Capture the
    // existing categories (keyed by the unique `name`) before the wipe and
    // re-apply them to matching imported codes, so classification survives a v1
    // import. Only v1's own fields (id/name/is_billable) come from the backup.
    final preservedCostCodeCategories = <String, String>{};
    final existingCostCodes = await _db
        .customSelect(
            'SELECT name, category FROM cost_codes WHERE category IS NOT NULL')
        .get();
    for (final r in existingCostCodes) {
      final name = r.data['name'];
      final category = r.data['category'];
      if (name is String && category is String) {
        preservedCostCodeCategories[name] = category;
      }
    }

    // FK enforcement can't be toggled inside a transaction (SQLite ignores it
    // there), so disable it around the whole operation and restore afterwards.
    await _db.customStatement('PRAGMA foreign_keys = OFF');
    try {
      await _db.transaction(() async {
        // 1. Wipe everything, children first.
        for (final name in _childToParentOrder) {
          await _db.customStatement('DELETE FROM $name');
        }

        // 2. Repopulate, parents first.
        for (final name in _childToParentOrder.reversed) {
          final rowsRaw = tables[name];
          if (rowsRaw == null) continue; // table absent from this backup
          if (rowsRaw is! List) {
            warnings.add("Skipped '$name': expected a list of rows.");
            continue;
          }
          if (rowsRaw.isEmpty) {
            rowsByTable[name] = 0;
            continue;
          }

          final validColumns = await _columnsOf(name);
          if (validColumns.isEmpty) {
            warnings.add("Skipped unknown table '$name'.");
            continue;
          }

          final droppedColumns = <String>{};
          var inserted = 0;
          for (final rowRaw in rowsRaw) {
            if (rowRaw is! Map<String, dynamic>) continue;
            final filtered = <String, dynamic>{};
            for (final entry in rowRaw.entries) {
              if (validColumns.contains(entry.key)) {
                filtered[entry.key] = entry.value;
              } else {
                droppedColumns.add(entry.key);
              }
            }
            if (filtered.isEmpty) continue;
            if (isLegacyDollars) _dollarsToCents(name, filtered);
            if (name == 'worker_payments') _applyWorkerPaymentDefaults(filtered);
            if (name == 'cost_codes') {
              // Re-apply the preserved v2 category for a code that already
              // existed (matched by name); leave it null for genuinely new codes
              // (they surface as "needs review" until classified).
              final codeName = filtered['name'];
              if (codeName is String) {
                final preserved = preservedCostCodeCategories[codeName];
                if (preserved != null) filtered['category'] = preserved;
              }
            }
            await _insertRow(name, filtered);
            inserted++;
          }
          rowsByTable[name] = inserted;

          // The invoices' inline payment columns are intentionally migrated to
          // `invoice_payments` below, not ignored — don't warn about them.
          if (name == 'invoices') droppedColumns.removeAll(_legacyInvoicePaymentColumns);
          if (droppedColumns.isNotEmpty) {
            final cols = (droppedColumns.toList()..sort()).join(', ');
            warnings.add(
              "Table '$name': ignored column(s) not in v2 schema: $cols.",
            );
          }
        }

        // Legacy payment backfill. Older backups (and any v23 export) stored a
        // single payment inline on each invoice row (`is_paid`, `amount_paid`,
        // `payment_date`, `payment_method`, `payment_reference`,
        // `payment_notes`). Those columns no longer exist, so the loop above
        // dropped them. Re-materialise them as `invoice_payments` rows — unless
        // the backup already carried its own `invoice_payments` table (a v2 app
        // export), in which case those rows were imported verbatim above.
        if (tables['invoice_payments'] == null) {
          final invoiceRows = tables['invoices'];
          if (invoiceRows is List) {
            var made = 0;
            for (final raw in invoiceRows) {
              if (raw is! Map<String, dynamic>) continue;
              final amt = raw['amount_paid'];
              if (amt is! num || amt <= 0) continue;
              final cents = isLegacyDollars ? (amt * 100).round() : amt.round();
              final date =
                  (raw['payment_date'] ?? raw['invoice_date'] ?? '').toString();
              await _insertRow('invoice_payments', {
                'invoice_id': raw['id'],
                'amount': cents,
                'payment_date': date,
                'payment_method': raw['payment_method'],
                'payment_reference': raw['payment_reference'],
                'payment_notes': raw['payment_notes'],
                'is_void': 0,
                'created_at': date,
              });
              made++;
            }
            if (made > 0) rowsByTable['invoice_payments'] = made;
          }
        }

        // Note any backup tables we don't recognise at all.
        for (final name in tables.keys) {
          if (!_childToParentOrder.contains(name)) {
            warnings.add("Ignored unrecognised table '$name' in backup.");
          }
        }
      });
    } finally {
      await _db.customStatement('PRAGMA foreign_keys = ON');
    }

    return BackupImportResult(rowsByTable: rowsByTable, warnings: warnings);
  }

  /// Live column names for [table], read from the schema so we only ever insert
  /// columns that actually exist in v2. Table names come from our hard-coded
  /// list, never user input, so interpolation here is safe.
  Future<Set<String>> _columnsOf(String table) async {
    final rows = await _db.customSelect('PRAGMA table_info($table)').get();
    return rows.map((r) => r.data['name'] as String).toSet();
  }

  /// In place, multiplies each money column of [row] by 100 (dollars → cents)
  /// for a legacy v1 backup. Null values are left null; non-numeric values are
  /// left untouched. Tables with no money columns are a no-op.
  void _dollarsToCents(String table, Map<String, dynamic> row) {
    final cols = _moneyColumnsByTable[table];
    if (cols == null) return;
    for (final c in cols) {
      final v = row[c];
      if (v is num) row[c] = (v * 100).round();
    }
  }

  /// Backups predating the payroll schema (every v1 export, and any v2 export
  /// made before schema v5) carry no `project_id` / `payment_type` on
  /// `worker_payments` rows. The v5 `payment_type` column is NOT NULL, so set
  /// the documented import defaults explicitly: `project_id` → null,
  /// `payment_type` → 'wage'. `putIfAbsent` preserves any values a newer backup
  /// already includes.
  void _applyWorkerPaymentDefaults(Map<String, dynamic> row) {
    row.putIfAbsent('project_id', () => null);
    row.putIfAbsent('payment_type', () => 'wage');
  }

  Future<void> _insertRow(String table, Map<String, dynamic> row) async {
    final cols = row.keys.toList();
    final columnList = cols.join(', ');
    final placeholders = List.filled(cols.length, '?').join(', ');
    final variables = cols.map((c) => _toVariable(row[c])).toList();
    await _db.customInsert(
      'INSERT OR REPLACE INTO $table ($columnList) VALUES ($placeholders)',
      variables: variables,
    );
  }

  Variable _toVariable(dynamic value) {
    if (value == null) return const Variable(null);
    if (value is int) return Variable<int>(value);
    if (value is double) return Variable<double>(value);
    if (value is bool) return Variable<bool>(value);
    if (value is String) return Variable<String>(value);
    // Anything unexpected (nested JSON) is stored as its textual form.
    return Variable<String>(value.toString());
  }
}
