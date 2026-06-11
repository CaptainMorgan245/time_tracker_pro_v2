import 'package:drift/drift.dart';

/// App-level settings (single row, id == 1). Distinct from the company /
/// tax profile in [CompanySettingsTable]. Generated row class: `DbSetting`.
@DataClassName('DbSetting')
class Settings extends Table {
  IntColumn get id => integer()();
  TextColumn get employeeNumberPrefix => text().nullable()();
  IntColumn get nextEmployeeNumber => integer().nullable()();
  TextColumn get vehicleDesignations => text().nullable()();
  TextColumn get vendors => text().nullable()();
  RealColumn get companyHourlyRate => real().nullable()();
  RealColumn get burdenRate => real().nullable()();
  IntColumn get timeRoundingInterval => integer().nullable()();
  IntColumn get autoBackupReminderFrequency => integer().nullable()();
  IntColumn get appRunsSinceBackup => integer().nullable()();
  TextColumn get measurementSystem => text().nullable()();
  IntColumn get defaultReportMonths => integer().nullable()();
  RealColumn get expenseMarkupPercentage => real().nullable()();
  IntColumn get setupCompleted => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
