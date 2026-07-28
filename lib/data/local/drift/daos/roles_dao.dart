import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/roles.dart';

part 'roles_dao.g.dart';

/// DAO for [Roles].
@DriftAccessor(tables: [Roles])
class RolesDao extends DatabaseAccessor<AppDatabase> with _$RolesDaoMixin {
  RolesDao(super.db);

  /// Ordered by name, case-insensitively — see [_byName].
  Future<List<DbRole>> getAll() => _byName().get();

  Stream<List<DbRole>> watchAll() => _byName().watch();

  /// `SELECT … ORDER BY name COLLATE NOCASE`, so every role picker and list is
  /// alphabetical without each screen sorting for itself.
  SimpleSelectStatement<$RolesTable, DbRole> _byName() => select(roles)
    ..orderBy([(t) => OrderingTerm(expression: t.name.collate(Collate.noCase))]);

  Future<DbRole?> getById(int id) =>
      (select(roles)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertRow(RolesCompanion entry) => into(roles).insert(entry);

  Future<bool> updateRow(RolesCompanion entry) => update(roles).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(roles)..where((t) => t.id.equals(id))).go();
}
