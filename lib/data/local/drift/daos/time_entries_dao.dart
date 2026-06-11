import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/time_entries.dart';

part 'time_entries_dao.g.dart';

/// DAO for [TimeEntries].
@DriftAccessor(tables: [TimeEntries])
class TimeEntriesDao extends DatabaseAccessor<AppDatabase>
    with _$TimeEntriesDaoMixin {
  TimeEntriesDao(super.db);

  Future<List<DbTimeEntry>> getAll() => select(timeEntries).get();

  Stream<List<DbTimeEntry>> watchAll() => select(timeEntries).watch();

  Future<DbTimeEntry?> getById(int id) =>
      (select(timeEntries)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<DbTimeEntry>> getByProject(int projectId) =>
      (select(timeEntries)..where((t) => t.projectId.equals(projectId))).get();

  Future<int> insertRow(TimeEntriesCompanion entry) =>
      into(timeEntries).insert(entry);

  Future<bool> updateRow(TimeEntriesCompanion entry) =>
      update(timeEntries).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(timeEntries)..where((t) => t.id.equals(id))).go();
}
