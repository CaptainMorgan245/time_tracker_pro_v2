import 'package:drift/drift.dart';

import 'employees.dart';
import 'projects.dart';

/// Payments made to workers/employees. References [Employees] and (optionally)
/// the [Projects] the payment is attributed to. Row class: `DbWorkerPayment`.
@DataClassName('DbWorkerPayment')
class WorkerPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get employeeId => integer().references(Employees, #id)();

  /// Project this payment is attributed to. Null for general (non-project)
  /// payments. Required at the application layer when [paymentType] is
  /// `'dividend'` — that rule is enforced in code, not in the schema.
  IntColumn get projectId =>
      integer().nullable().references(Projects, #id)();

  TextColumn get paymentDate => text()();

  /// Amount in integer **cents** (converted from dollars in the v4 cents
  /// migration).
  IntColumn get amount => integer()();

  /// Either `'wage'` or `'dividend'`. Non-nullable, and intentionally has no DB
  /// default so every insert must state the type explicitly.
  TextColumn get paymentType => text()();

  TextColumn get note => text().nullable()();
  TextColumn get createdAt => text()();
}
