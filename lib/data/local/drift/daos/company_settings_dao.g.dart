// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_settings_dao.dart';

// ignore_for_file: type=lint
mixin _$CompanySettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CompanySettingsTableTable get companySettingsTable =>
      attachedDatabase.companySettingsTable;
  CompanySettingsDaoManager get managers => CompanySettingsDaoManager(this);
}

class CompanySettingsDaoManager {
  final _$CompanySettingsDaoMixin _db;
  CompanySettingsDaoManager(this._db);
  $$CompanySettingsTableTableTableManager get companySettingsTable =>
      $$CompanySettingsTableTableTableManager(
        _db.attachedDatabase,
        _db.companySettingsTable,
      );
}
