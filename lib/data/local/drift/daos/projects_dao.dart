import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/projects.dart';

part 'projects_dao.g.dart';

/// DAO for [Projects].
@DriftAccessor(tables: [Projects])
class ProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectsDaoMixin {
  ProjectsDao(super.db);

  Future<List<DbProject>> getAll() => select(projects).get();

  Stream<List<DbProject>> watchAll() => select(projects).watch();

  Future<DbProject?> getById(int id) =>
      (select(projects)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertRow(ProjectsCompanion entry) =>
      into(projects).insert(entry);

  Future<bool> updateRow(ProjectsCompanion entry) =>
      update(projects).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(projects)..where((t) => t.id.equals(id))).go();
}
