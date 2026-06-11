import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/company_settings.dart';

part 'company_settings_dao.g.dart';

/// DAO for the single-row [CompanySettingsTable] (id == 1).
@DriftAccessor(tables: [CompanySettingsTable])
class CompanySettingsDao extends DatabaseAccessor<AppDatabase>
    with _$CompanySettingsDaoMixin {
  CompanySettingsDao(super.db);

  static const int settingsRowId = 1;

  /// Returns the settings row, creating defaults on first access.
  Future<DbCompanySetting> getSettings() async {
    final existing = await (select(companySettingsTable)
          ..where((t) => t.id.equals(settingsRowId)))
        .getSingleOrNull();
    if (existing != null) return existing;

    await into(companySettingsTable).insert(
      const CompanySettingsTableCompanion(id: Value(settingsRowId)),
      mode: InsertMode.insertOrIgnore,
    );
    return (select(companySettingsTable)
          ..where((t) => t.id.equals(settingsRowId)))
        .getSingle();
  }

  Stream<DbCompanySetting?> watchSettings() =>
      (select(companySettingsTable)..where((t) => t.id.equals(settingsRowId)))
          .watchSingleOrNull();

  Future<void> saveSettings(CompanySettingsTableCompanion entry) =>
      into(companySettingsTable).insertOnConflictUpdate(
        entry.copyWith(id: const Value(settingsRowId)),
      );
}
