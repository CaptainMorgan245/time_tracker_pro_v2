import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/clients_dao.dart';
import 'daos/company_settings_dao.dart';
import 'daos/cost_codes_dao.dart';
import 'daos/employees_dao.dart';
import 'daos/expense_categories_dao.dart';
import 'daos/invoice_payments_dao.dart';
import 'daos/invoices_dao.dart';
import 'daos/materials_dao.dart';
import 'daos/projects_dao.dart';
import 'daos/roles_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/time_entries_dao.dart';
import 'daos/worker_payments_dao.dart';
import 'tables/clients.dart';
import 'tables/company_settings.dart';
import 'tables/cost_codes.dart';
import 'tables/employees.dart';
import 'tables/expense_categories.dart';
import 'tables/invoice_payments.dart';
import 'tables/invoices.dart';
import 'tables/materials.dart';
import 'tables/projects.dart';
import 'tables/roles.dart';
import 'tables/settings.dart';
import 'tables/time_entries.dart';
import 'tables/worker_payments.dart';

part 'app_database.g.dart';

/// The application's Drift database — the full schema ported from the original
/// app's v23 definition (12 tables). Run `dart run build_runner build` after
/// changing any table or DAO.
///
/// NOTE ON [schemaVersion]: this is a greenfield database, so versioning
/// restarts at 1 and [onCreate] builds the entire schema at once. The *schema
/// content* is the v23 schema; the version number is unrelated to the old
/// app's 23. If we later need to import an existing old-app database file we'll
/// align this number and add an `onUpgrade` migration path.
@DriftDatabase(
  tables: [
    Settings,
    Clients,
    Projects,
    Roles,
    Employees,
    CostCodes,
    ExpenseCategories,
    Invoices,
    InvoicePayments,
    TimeEntries,
    Materials,
    CompanySettingsTable,
    WorkerPayments,
  ],
  daos: [
    SettingsDao,
    ClientsDao,
    ProjectsDao,
    RolesDao,
    EmployeesDao,
    CostCodesDao,
    ExpenseCategoriesDao,
    InvoicesDao,
    InvoicePaymentsDao,
    TimeEntriesDao,
    MaterialsDao,
    CompanySettingsDao,
    WorkerPaymentsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the on-device database file `time_tracker_pro.sqlite`.
  ///
  /// The `web:` options are required when compiling for the web (drift_flutter
  /// otherwise throws "the 'web' parameter needs to be set"). They point at the
  /// `sqlite3.wasm` and `drift_worker.js` artifacts that must live in `web/`
  /// (matched to the sqlite3/drift versions in pubspec.lock).
  AppDatabase()
      : super(
          driftDatabase(
            name: 'time_tracker_pro',
            web: DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.js'),
            ),
          ),
        );

  /// Lets tests inject an in-memory executor (e.g. `NativeDatabase.memory()`).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDefaults();
        },
        // Each transition below is a real, data-preserving migration, handled by
        // its own explicit branch. Any transition WITHOUT a branch falls through
        // to the DEVELOPMENT-ONLY destructive rebuild: wipe, recreate from
        // scratch, re-seed defaults, and re-import real data from a v23 backup.
        //
        // ⚠️ So when bumping `schemaVersion`, ALWAYS add the matching
        // `from == n && to == n + 1` branch here first — omitting it silently
        // destroys user data on upgrade instead of failing loudly.
        onUpgrade: (m, from, to) async {
          if (from == 2 && to == 3) {
            await _migrateV2ToV3(m);
            return;
          }
          if (from == 4 && to == 5) {
            await _migrateV4ToV5(m);
            return;
          }
          if (from == 5 && to == 6) {
            await _migrateV5ToV6(m);
            return;
          }
          if (from == 6 && to == 7) {
            await _migrateV6ToV7();
            return;
          }
          if (from == 7 && to == 8) {
            await _migrateV7ToV8();
            return;
          }
          await destroyEverything(m);
          await m.createAll();
          await seedDefaults();
        },
        beforeOpen: (details) async {
          // Enforce foreign keys for every connection. This must live here, not
          // in a migration: drift runs migrations with foreign keys disabled.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Drops every table/index/trigger in the current schema, leaving an empty
  /// database. Used by the development [onUpgrade] path above to start from a
  /// clean slate before recreating. Foreign keys are disabled during
  /// migrations, so drop order is unconstrained.
  Future<void> destroyEverything(Migrator m) async {
    for (final entity in allSchemaEntities.toList().reversed) {
      await m.drop(entity);
    }
  }

  /// Data-preserving migration from schema v2 to v3: invoice payment state moves
  /// off the `invoices` row and into the new [InvoicePayments] table.
  ///
  /// Steps, in order (foreign keys are disabled during migrations):
  ///   1. Create `invoice_payments` and its `invoice_id` index.
  ///   2. One-time data pass — for every invoice that carried a payment
  ///      (`amount_paid` not null and > 0), insert one non-void payment row from
  ///      the existing inline fields. A missing `payment_date` falls back to the
  ///      invoice date so the not-null payment/created date columns are honoured.
  ///   3. Drop the now-redundant inline payment columns from `invoices`
  ///      (`is_paid`, `amount_paid`, `payment_date`, `payment_method`,
  ///      `payment_reference`, `payment_notes`) by recreating the table from its
  ///      current Dart definition.
  Future<void> _migrateV2ToV3(Migrator m) async {
    await m.createTable(invoicePayments);
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_invoice_payments_invoice '
      'ON invoice_payments (invoice_id)',
    );

    await customStatement('''
      INSERT INTO invoice_payments
        (invoice_id, amount, payment_date, payment_method,
         payment_reference, payment_notes, is_void, created_at)
      SELECT id, amount_paid, COALESCE(payment_date, invoice_date),
             payment_method, payment_reference, payment_notes, 0,
             COALESCE(payment_date, invoice_date)
      FROM invoices
      WHERE amount_paid IS NOT NULL AND amount_paid > 0
    ''');

    // Recreate `invoices` from its updated definition; columns no longer present
    // in the Dart table (the inline payment fields) are dropped.
    await m.alterTable(TableMigration(invoices));
  }

  /// Schema migration from v4 to v5: `worker_payments` gains `project_id`
  /// (nullable, FK → projects) and a non-nullable `payment_type`
  /// (`'wage'` / `'dividend'`).
  ///
  /// The table is empty in v2 (no payroll feature has written to it yet), so it
  /// is recreated wholesale rather than ALTERed in place — a NOT NULL column
  /// with no default can't otherwise be added. NOTE: `amount` is ALREADY integer
  /// cents (converted in the earlier cents migration), so there is deliberately
  /// no dollars→cents conversion here.
  Future<void> _migrateV4ToV5(Migrator m) async {
    await m.drop(workerPayments);
    await m.createTable(workerPayments);
  }

  /// Schema migration from v5 to v6: `cost_codes` gains a nullable `category`
  /// column (`contract` / `billable` / `no_charge` / `internal`), the semantic
  /// classification that drives the analytics Project Financial Summary roll-up.
  ///
  /// Data-preserving: existing rows keep their `is_billable` flag (unchanged —
  /// it still governs T&M line selection) and start with `category = NULL`,
  /// which analytics treats as "needs review" until a code is classified via
  /// the cost-code management screen. Nullable, so a plain ADD COLUMN suffices.
  Future<void> _migrateV5ToV6(Migrator m) async {
    await m.addColumn(costCodes, costCodes.category);
  }

  /// Migration from schema v6 to v7: **data only, no schema change.** Renumbers
  /// the two invoices an earlier build emitted in the wrong format back onto the
  /// canonical `PREFIX-YYYY-NNN` sequence (see `nextInvoiceNumber`):
  ///
  ///   `INV-0024` → `INV-2026-024`   (id 31)
  ///   `INV-0025` → `INV-2026-025`
  ///
  /// Runs inside drift's migration, so it completes before the app can issue any
  /// query — no new invoice can take `INV-2026-024` first and collide. The schema
  /// version is itself the run-once gate: once the database reports v7 this never
  /// executes again.
  ///
  /// Deliberately defensive, because a migration that throws leaves the app
  /// unable to open:
  ///   - matches on `invoice_number` (UNIQUE, so at most one row) rather than
  ///     `id`, which differs between databases;
  ///   - the `NOT EXISTS` guard lives INSIDE the `UPDATE`, so check-and-write is
  ///     a single atomic statement. A separate pre-`SELECT` would leave a
  ///     check-then-write gap that two web tabs running `onUpgrade` concurrently
  ///     could both pass, the second then violating the UNIQUE constraint. This
  ///     way re-application is a no-op even against a concurrent writer;
  ///   - a missing source row, or a target already taken, simply updates nothing.
  ///
  /// Platform-independent: drift core runs the strategy, `user_version` is the
  /// gate, and this is plain SQLite — identical under `NativeDatabase` and
  /// `WasmDatabase`. Note the two platforms use *separate* stores, so a fresh web
  /// profile runs `onCreate` at v7 and never needs this.
  Future<void> _migrateV6ToV7() async {
    const renumbering = <String, String>{
      'INV-0024': 'INV-2026-024',
      'INV-0025': 'INV-2026-025',
    };

    for (final entry in renumbering.entries) {
      await customUpdate(
        'UPDATE invoices SET invoice_number = ? '
        'WHERE invoice_number = ? '
        '  AND NOT EXISTS (SELECT 1 FROM invoices WHERE invoice_number = ?)',
        variables: [
          Variable.withString(entry.value),
          Variable.withString(entry.key),
          Variable.withString(entry.value),
        ],
        updates: {invoices},
      );
    }
  }

  /// Migration from schema v7 to v8: **data only, no schema change.** Separates
  /// the two rate columns that the old "Burden Rate" tab wrote as one value.
  ///
  /// Until now a single input saved the same number to BOTH `burden_rate`
  /// (dollars, internal cost) and `company_hourly_rate` (cents), and nothing
  /// read `company_hourly_rate` at all. It now backs the **Default Billing
  /// Rate** — the rate a project with no `billed_hourly_rate` of its own
  /// charges the client (see `hourlyRateCents`).
  ///
  /// So the existing value in that column is not a billing rate at all, it is a
  /// stale copy of the cost rate. Leaving it would silently invoice fallback
  /// work at exactly cost, zero margin — worse than the bug this fixes. It is
  /// therefore overwritten UNCONDITIONALLY with the configured billing rate
  /// rather than only filled when empty.
  ///
  /// `burden_rate` is deliberately untouched: it keeps the real cost figure.
  ///
  /// Run-once gated by the schema version, like [_migrateV6ToV7]. Defensive in
  /// the same way — a single statement, and a no-op if the settings row is
  /// missing, because a migration that throws leaves the app unable to open.
  Future<void> _migrateV7ToV8() async {
    const defaultBillingRateCents = 7492; // $74.92/hour
    await customUpdate(
      'UPDATE settings SET company_hourly_rate = ? WHERE id = 1',
      variables: [Variable.withInt(defaultBillingRateCents)],
      updates: {settings},
    );
  }

  /// Inserts the default singleton rows plus the internal "Company Expenses"
  /// client and project, matching the v23 `onCreate` seed. Shared by the create
  /// and (development) upgrade paths, and by `BackupRepository.clearAllData`
  /// after a destructive wipe so the app is left in a usable state.
  Future<void> seedDefaults() async {
    // Default app-settings row (id == 1).
    await into(settings).insert(
      SettingsCompanion.insert(
        id: const Value(1),
        nextEmployeeNumber: const Value(1),
        // Default Billing Rate ($74.92/hour, in cents) — what a project with no
        // rate of its own bills at. Distinct from burdenRate (internal cost).
        companyHourlyRate: const Value(7492),
        burdenRate: const Value(0.0),
        timeRoundingInterval: const Value(15),
        autoBackupReminderFrequency: const Value(10),
        appRunsSinceBackup: const Value(0),
        defaultReportMonths: const Value(3),
        expenseMarkupPercentage: const Value(0.0),
        setupCompleted: const Value(0),
      ),
    );

    // Default company-settings row (id == 1).
    await into(companySettingsTable).insert(
      const CompanySettingsTableCompanion(id: Value(1)),
    );

    // Seed the "Company Expenses" client + internal project so company
    // expenses have somewhere to attach (matches v23 onCreate).
    final companyExpensesClientId = await into(clients).insert(
      ClientsCompanion.insert(
        name: 'Company Expenses',
        isActive: const Value(1),
      ),
    );
    await into(projects).insert(
      ProjectsCompanion.insert(
        projectName: 'Internal Company Project',
        clientId: companyExpensesClientId,
        pricingModel: const Value('hourly'),
        isCompleted: const Value(0),
        isInternal: const Value(1),
        expenseMarkupPercentage: const Value(15.0),
        taxRate: const Value(5.0),
      ),
    );
  }
}
