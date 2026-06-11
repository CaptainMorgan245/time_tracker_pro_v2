import 'package:drift/drift.dart';

/// Cost codes for categorising time/materials. Row class: `DbCostCode`.
@DataClassName('DbCostCode')
class CostCodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get isBillable => integer().withDefault(const Constant(0))();
}
