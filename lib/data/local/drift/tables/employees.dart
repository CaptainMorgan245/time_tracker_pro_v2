import 'package:drift/drift.dart';

import 'roles.dart';

/// Employees. `titleId` references [Roles]. Row class: `DbEmployee`.
@DataClassName('DbEmployee')
class Employees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get employeeNumber => text().unique().nullable()();
  TextColumn get name => text()();
  IntColumn get titleId => integer().nullable().references(Roles, #id)();
  IntColumn get hourlyRate => integer().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}
