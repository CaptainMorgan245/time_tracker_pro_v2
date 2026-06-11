import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/settings.dart';

part 'settings_dao.g.dart';

/// DAO for the single-row app [Settings] table (id == 1).
@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  static const int settingsRowId = 1;

  Future<DbSetting?> getSettings() =>
      (select(settings)..where((t) => t.id.equals(settingsRowId)))
          .getSingleOrNull();

  Stream<DbSetting?> watchSettings() =>
      (select(settings)..where((t) => t.id.equals(settingsRowId)))
          .watchSingleOrNull();

  Future<void> saveSettings(SettingsCompanion entry) =>
      into(settings).insertOnConflictUpdate(
        entry.copyWith(id: const Value(settingsRowId)),
      );
}
