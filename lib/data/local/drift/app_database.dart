import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/clients_dao.dart';
import 'daos/company_settings_dao.dart';
import 'daos/cost_codes_dao.dart';
import 'daos/employees_dao.dart';
import 'daos/expense_categories_dao.dart';
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDefaults();
        },
        // DEVELOPMENT-ONLY strategy: any schemaVersion bump wipes the database
        // and rebuilds it from scratch, then re-seeds defaults. Real data is
        // re-imported from a v23 backup afterwards, so incremental migrations
        // aren't needed yet. Replace this with proper stepwise migrations
        // before shipping a build that existing users will upgrade in place.
        onUpgrade: (m, from, to) async {
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
        companyHourlyRate: const Value(0.0),
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
