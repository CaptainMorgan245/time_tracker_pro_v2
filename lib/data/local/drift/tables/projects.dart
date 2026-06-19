import 'package:drift/drift.dart';

import 'clients.dart';

/// Projects. References [Clients] and (optionally) a parent project.
/// Row class: `DbProject`.
@DataClassName('DbProject')
class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get projectName => text()();
  IntColumn get clientId => integer().references(Clients, #id)();
  TextColumn get city => text().nullable()();
  TextColumn get streetAddress => text().nullable()();
  TextColumn get region => text().nullable()();
  TextColumn get postalCode => text().nullable()();
  TextColumn get pricingModel =>
      text().withDefault(const Constant('hourly'))();
  IntColumn get isCompleted => integer().withDefault(const Constant(0))();
  TextColumn get completionDate => text().nullable()();
  IntColumn get isInternal => integer().withDefault(const Constant(0))();
  IntColumn get billedHourlyRate => integer().nullable()();
  IntColumn get projectPrice => integer().nullable()();
  RealColumn get expenseMarkupPercentage =>
      real().withDefault(const Constant(15.0))();
  RealColumn get taxRate => real().withDefault(const Constant(5.0))();
  IntColumn get parentProjectId =>
      integer().nullable().references(Projects, #id)();
}
