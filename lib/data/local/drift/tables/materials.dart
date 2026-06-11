import 'package:drift/drift.dart';

import 'cost_codes.dart';
import 'invoices.dart';
import 'projects.dart';

/// Materials / expenses tied to a project. References [Projects], [CostCodes]
/// and [Invoices]. Row class: `DbMaterial`.
@DataClassName('DbMaterial')
class Materials extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id)();
  TextColumn get itemName => text()();
  RealColumn get cost => real()();
  TextColumn get purchaseDate => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
  TextColumn get expenseCategory => text().nullable()();
  TextColumn get unit => text().nullable()();
  RealColumn get quantity => real().nullable()();
  RealColumn get baseQuantity => real().nullable()();
  RealColumn get odometerReading => real().nullable()();
  IntColumn get isCompanyExpense => integer().withDefault(const Constant(0))();
  TextColumn get vehicleDesignation => text().nullable()();
  TextColumn get vendorOrSubtrade => text().nullable()();
  IntColumn get costCodeId =>
      integer().nullable().references(CostCodes, #id)();
  IntColumn get isBilled => integer().withDefault(const Constant(0))();
  IntColumn get invoiceId => integer().nullable().references(Invoices, #id)();
}
