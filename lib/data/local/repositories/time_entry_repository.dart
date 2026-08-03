import '../drift/app_database.dart';
import '../drift/daos/time_entries_dao.dart';

/// Thin CRUD wrapper around [TimeEntriesDao]. Contains no business logic — it
/// only forwards calls to the DAO so the presentation layer depends on a
/// repository surface rather than Drift directly.
class TimeEntryRepository {
  TimeEntryRepository(this._dao);

  final TimeEntriesDao _dao;

  /// Completed, non-deleted entries for the records list, newest first.
  Stream<List<DbTimeEntry>> watchCompleted() => _dao.watchCompleted();

  /// Unbilled, completed, non-deleted entries for [projectId] — the candidate
  /// lines for a new invoice.
  Stream<List<DbTimeEntry>> watchUnbilledByProject(int projectId) =>
      _dao.watchUnbilledByProject(projectId);

  Future<DbTimeEntry?> getById(int id) => _dao.getById(id);

  Future<int> insertRow(TimeEntriesCompanion entry) => _dao.insertRow(entry);

  Future<bool> updateRow(TimeEntriesCompanion entry) => _dao.updateRow(entry);

  /// Soft-delete (sets `isDeleted = 1`), matching the original app.
  Future<int> softDelete(int id) => _dao.softDeleteById(id);
}
