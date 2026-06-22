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
  AppDatabase() : super(driftDatabase(name: 'time_tracker_pro'));

  /// Lets tests inject an in-memory executor (e.g. `NativeDatabase.memory()`).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDefaults();
        },
        // v2 → v3 is a real, data-preserving migration (move inline invoice
        // payment fields into the new `invoice_payments` table). Every *other*
        // version transition still uses the DEVELOPMENT-ONLY destructive
        // rebuild: wipe, recreate from scratch, re-seed defaults, and re-import
        // real data from a v23 backup. Replace that fallback with proper
        // stepwise migrations before shipping in-place upgrades to users.
        onUpgrade: (m, from, to) async {
          if (from == 2 && to == 3) {
            await _migrateV2ToV3(m);
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
        companyHourlyRate: const Value(0),
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
