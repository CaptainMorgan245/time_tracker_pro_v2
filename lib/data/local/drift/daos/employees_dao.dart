import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/employees.dart';

part 'employees_dao.g.dart';

/// DAO for [Employees].
@DriftAccessor(tables: [Employees])
class EmployeesDao extends DatabaseAccessor<AppDatabase>
    with _$EmployeesDaoMixin {
  EmployeesDao(super.db);

  Future<List<DbEmployee>> getAll() => select(employees).get();

  Stream<List<DbEmployee>> watchAll() => select(employees).watch();

  Future<DbEmployee?> getById(int id) =>
      (select(employees)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertRow(EmployeesCompanion entry) =>
      into(employees).insert(entry);

  Future<bool> updateRow(EmployeesCompanion entry) =>
      update(employees).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(employees)..where((t) => t.id.equals(id))).go();
}
