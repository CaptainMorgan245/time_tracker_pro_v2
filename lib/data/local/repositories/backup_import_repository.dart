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

/// Imports a JSON backup produced by the original Time Tracker Pro app
/// (`AppDatabase.exportDatabaseToJson`). The payload looks like:
///
/// ```json
/// {
///   "export_format_version": 1,
///   "database_version": 23,
///   "tables": { "clients": [ { "id": 1, ... } ], "projects": [ ... ], ... }
/// }
/// ```
///
/// Each row carries its original primary key, so foreign-key relationships are
/// preserved verbatim. This is a **destructive replace**: every table is wiped
/// and repopulated inside a single transaction, so any failure rolls the whole
/// database back to its pre-import state.
class BackupImportRepository {
  BackupImportRepository(this._db);

  final AppDatabase _db;

  /// Tables in child-before-parent order. Used directly for the wipe (delete
  /// children first) and reversed for inserts (parents first) so foreign keys
  /// are always satisfiable even if FK enforcement is on.
  static const List<String> _childToParentOrder = [
    'time_entries',
    'materials',
    'worker_payments',
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

    final rowsByTable = <String, int>{};
    final warnings = <String>[];

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
            await _insertRow(name, filtered);
            inserted++;
          }
          rowsByTable[name] = inserted;

          if (droppedColumns.isNotEmpty) {
            final cols = (droppedColumns.toList()..sort()).join(', ');
            warnings.add(
              "Table '$name': ignored column(s) not in v2 schema: $cols.",
            );
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
