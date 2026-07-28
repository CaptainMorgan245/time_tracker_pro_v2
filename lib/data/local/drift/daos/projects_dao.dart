import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/projects.dart';

part 'projects_dao.g.dart';

/// DAO for [Projects].
@DriftAccessor(tables: [Projects])
class ProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectsDaoMixin {
  ProjectsDao(super.db);

  /// Ordered by project name, case-insensitively — see [_byName].
  Future<List<DbProject>> getAll() => _byName().get();

  Stream<List<DbProject>> watchAll() => _byName().watch();

  /// `SELECT … ORDER BY project_name COLLATE NOCASE`, so every project picker
  /// and list is alphabetical without each screen sorting for itself.
  SimpleSelectStatement<$ProjectsTable, DbProject> _byName() => select(projects)
    ..orderBy([
      (t) => OrderingTerm(expression: t.projectName.collate(Collate.noCase))
    ]);

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
