import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/roles.dart';

part 'roles_dao.g.dart';

/// DAO for [Roles].
@DriftAccessor(tables: [Roles])
class RolesDao extends DatabaseAccessor<AppDatabase> with _$RolesDaoMixin {
  RolesDao(super.db);

  Future<List<DbRole>> getAll() => select(roles).get();

  Stream<List<DbRole>> watchAll() => select(roles).watch();

  Future<DbRole?> getById(int id) =>
      (select(roles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertRow(RolesCompanion entry) => into(roles).insert(entry);

  Future<bool> updateRow(RolesCompanion entry) => update(roles).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(roles)..where((t) => t.id.equals(id))).go();
}
