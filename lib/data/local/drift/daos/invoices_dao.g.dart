// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoices_dao.dart';

// ignore_for_file: type=lint
mixin _$InvoicesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $ProjectsTable get projects => attachedDatabase.projects;
  $InvoicesTable get invoices => attachedDatabase.invoices;
  InvoicesDaoManager get managers => InvoicesDaoManager(this);
}

class InvoicesDaoManager {
  final _$InvoicesDaoMixin _db;
  InvoicesDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db.attachedDatabase, _db.projects);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db.attachedDatabase, _db.invoices);
}
