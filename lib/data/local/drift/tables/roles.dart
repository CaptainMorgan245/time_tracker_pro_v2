import 'package:drift/drift.dart';

/// Employee roles / titles with a standard billing rate. Row class: `DbRole`.
@DataClassName('DbRole')
class Roles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  RealColumn get standardRate => real().withDefault(const Constant(0.0))();
}
