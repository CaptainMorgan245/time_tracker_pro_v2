// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_payments_dao.dart';

// ignore_for_file: type=lint
mixin _$WorkerPaymentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $RolesTable get roles => attachedDatabase.roles;
  $EmployeesTable get employees => attachedDatabase.employees;
  $WorkerPaymentsTable get workerPayments => attachedDatabase.workerPayments;
  WorkerPaymentsDaoManager get managers => WorkerPaymentsDaoManager(this);
}

class WorkerPaymentsDaoManager {
  final _$WorkerPaymentsDaoMixin _db;
  WorkerPaymentsDaoManager(this._db);
  $$RolesTableTableManager get roles =>
      $$RolesTableTableManager(_db.attachedDatabase, _db.roles);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db.attachedDatabase, _db.employees);
  $$WorkerPaymentsTableTableManager get workerPayments =>
      $$WorkerPaymentsTableTableManager(
        _db.attachedDatabase,
        _db.workerPayments,
      );
}
