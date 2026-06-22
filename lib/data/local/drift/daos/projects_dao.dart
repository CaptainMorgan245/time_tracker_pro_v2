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

  /// Sets a project's completion flag + date by id. Targeted partial update (no
  /// full-row replace), so only these two columns are touched. Returns the
  /// number of rows affected (0 means no project matched [id]).
  Future<int> setCompleted(int id, bool completed) =>
      (update(projects)..where((t) => t.id.equals(id))).write(
        ProjectsCompanion(
          isCompleted: Value(completed ? 1 : 0),
          completionDate:
              Value(completed ? DateTime.now().toIso8601String() : null),
        ),
      );

  Future<int> deleteById(int id) =>
      (delete(projects)..where((t) => t.id.equals(id))).go();
}
