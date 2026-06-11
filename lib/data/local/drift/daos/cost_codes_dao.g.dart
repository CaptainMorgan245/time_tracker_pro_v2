// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_codes_dao.dart';

// ignore_for_file: type=lint
mixin _$CostCodesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CostCodesTable get costCodes => attachedDatabase.costCodes;
  CostCodesDaoManager get managers => CostCodesDaoManager(this);
}

class CostCodesDaoManager {
  final _$CostCodesDaoMixin _db;
  CostCodesDaoManager(this._db);
  $$CostCodesTableTableManager get costCodes =>
      $$CostCodesTableTableManager(_db.attachedDatabase, _db.costCodes);
}
