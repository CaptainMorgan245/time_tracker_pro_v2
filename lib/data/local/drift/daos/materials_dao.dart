import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/materials.dart';

part 'materials_dao.g.dart';

/// DAO for [Materials].
@DriftAccessor(tables: [Materials])
class MaterialsDao extends DatabaseAccessor<AppDatabase>
    with _$MaterialsDaoMixin {
  MaterialsDao(super.db);

  Future<List<DbMaterial>> getAll() => select(materials).get();

  Stream<List<DbMaterial>> watchAll() => select(materials).watch();

  Future<DbMaterial?> getById(int id) =>
      (select(materials)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<DbMaterial>> getByProject(int projectId) =>
      (select(materials)..where((t) => t.projectId.equals(projectId))).get();

  Future<int> insertRow(MaterialsCompanion entry) =>
      into(materials).insert(entry);

  Future<bool> updateRow(MaterialsCompanion entry) =>
      update(materials).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(materials)..where((t) => t.id.equals(id))).go();
}
