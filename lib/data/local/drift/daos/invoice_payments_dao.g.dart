// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_payments_dao.dart';

// ignore_for_file: type=lint
mixin _$InvoicePaymentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $ProjectsTable get projects => attachedDatabase.projects;
  $InvoicesTable get invoices => attachedDatabase.invoices;
  $InvoicePaymentsTable get invoicePayments => attachedDatabase.invoicePayments;
  InvoicePaymentsDaoManager get managers => InvoicePaymentsDaoManager(this);
}

class InvoicePaymentsDaoManager {
  final _$InvoicePaymentsDaoMixin _db;
  InvoicePaymentsDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db.attachedDatabase, _db.projects);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db.attachedDatabase, _db.invoices);
  $$InvoicePaymentsTableTableManager get invoicePayments =>
      $$InvoicePaymentsTableTableManager(
        _db.attachedDatabase,
        _db.invoicePayments,
      );
}
