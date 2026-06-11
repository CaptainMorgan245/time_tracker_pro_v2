import 'package:drift/drift.dart';

import 'employees.dart';

/// Payments made to workers/employees. References [Employees].
/// Row class: `DbWorkerPayment`.
@DataClassName('DbWorkerPayment')
class WorkerPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get employeeId => integer().references(Employees, #id)();
  TextColumn get paymentDate => text()();
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();
  TextColumn get createdAt => text()();
}
