// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materials_dao.dart';

// ignore_for_file: type=lint
mixin _$MaterialsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $ProjectsTable get projects => attachedDatabase.projects;
  $CostCodesTable get costCodes => attachedDatabase.costCodes;
  $InvoicesTable get invoices => attachedDatabase.invoices;
  $MaterialsTable get materials => attachedDatabase.materials;
  MaterialsDaoManager get managers => MaterialsDaoManager(this);
}

class MaterialsDaoManager {
  final _$MaterialsDaoMixin _db;
  MaterialsDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db.attachedDatabase, _db.projects);
  $$CostCodesTableTableManager get costCodes =>
      $$CostCodesTableTableManager(_db.attachedDatabase, _db.costCodes);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db.attachedDatabase, _db.invoices);
  $$MaterialsTableTableManager get materials =>
      $$MaterialsTableTableManager(_db.attachedDatabase, _db.materials);
}
