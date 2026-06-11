import 'package:drift/drift.dart';

/// Clients. Generated row class: `DbClient`.
@DataClassName('DbClient')
class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  TextColumn get contactPerson => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
}
