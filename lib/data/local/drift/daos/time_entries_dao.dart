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

  /// Completed, non-deleted entries (the ones that show in the records list),
  /// newest first. Mirrors the original app's `is_deleted = 0 AND end_time IS
  /// NOT NULL ORDER BY start_time DESC`.
  Stream<List<DbTimeEntry>> watchCompleted() => (select(timeEntries)
        ..where((t) => t.isDeleted.equals(0) & t.endTime.isNotNull())
        ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
      .watch();

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

  /// Soft-delete: flags the row as deleted rather than removing it, matching the
  /// original app's `UPDATE time_entries SET is_deleted = 1 WHERE id = ?`.
  Future<int> softDeleteById(int id) =>
      (update(timeEntries)..where((t) => t.id.equals(id)))
          .write(const TimeEntriesCompanion(isDeleted: Value(1)));

  /// Releases all entries billed to [invoiceId] back to unbilled (used when an
  /// extras invoice is voided).
  Future<int> clearInvoiceLink(int invoiceId) =>
      (update(timeEntries)..where((t) => t.invoiceId.equals(invoiceId)))
          .write(const TimeEntriesCompanion(
        isBilled: Value(0),
        invoiceId: Value(null),
      ));
}
