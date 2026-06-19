import 'package:drift/drift.dart';

import 'cost_codes.dart';
import 'employees.dart';
import 'invoices.dart';
import 'projects.dart';

/// Time entries. References [Projects], [Employees], [CostCodes] and
/// [Invoices]. Row class: `DbTimeEntry`.
@DataClassName('DbTimeEntry')
class TimeEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  IntColumn get employeeId =>
      integer().nullable().references(Employees, #id)();
  TextColumn get startTime => text()();
  TextColumn get endTime => text().nullable()();
  RealColumn get pausedDuration => real().withDefault(const Constant(0.0))();
  RealColumn get finalBilledDurationSeconds => real().nullable()();
  IntColumn get hourlyRate => integer().nullable()();
  IntColumn get isPaused => integer().withDefault(const Constant(0))();
  TextColumn get pauseStartTime => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
  TextColumn get workDetails => text().nullable()();
  IntColumn get costCodeId =>
      integer().nullable().references(CostCodes, #id)();
  IntColumn get isBilled => integer().withDefault(const Constant(0))();
  IntColumn get invoiceId => integer().nullable().references(Invoices, #id)();
}
