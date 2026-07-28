import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/employees.dart';

part 'employees_dao.g.dart';

/// DAO for [Employees].
@DriftAccessor(tables: [Employees])
class EmployeesDao extends DatabaseAccessor<AppDatabase>
    with _$EmployeesDaoMixin {
  EmployeesDao(super.db);

  /// Ordered by name, case-insensitively — see [_byName].
  Future<List<DbEmployee>> getAll() => _byName().get();

  Stream<List<DbEmployee>> watchAll() => _byName().watch();

  /// `SELECT … ORDER BY name COLLATE NOCASE`, so every employee picker and list
  /// is alphabetical without each screen sorting for itself.
  SimpleSelectStatement<$EmployeesTable, DbEmployee> _byName() =>
      select(employees)
        ..orderBy(
            [(t) => OrderingTerm(expression: t.name.collate(Collate.noCase))]);

  Future<DbEmployee?> getById(int id) =>
      (select(employees)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertRow(EmployeesCompanion entry) =>
      into(employees).insert(entry);

  Future<bool> updateRow(EmployeesCompanion entry) =>
      update(employees).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(employees)..where((t) => t.id.equals(id))).go();
}
