import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/invoices.dart';

part 'invoices_dao.g.dart';

/// DAO for [Invoices].
@DriftAccessor(tables: [Invoices])
class InvoicesDao extends DatabaseAccessor<AppDatabase>
    with _$InvoicesDaoMixin {
  InvoicesDao(super.db);

  Future<List<DbInvoice>> getAll() => select(invoices).get();

  Stream<List<DbInvoice>> watchAll() => select(invoices).watch();

  Future<DbInvoice?> getById(int id) =>
      (select(invoices)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<DbInvoice>> getByProject(int projectId) =>
      (select(invoices)..where((t) => t.projectId.equals(projectId))).get();

  /// Sets the sent flag by id. Targeted partial update (no full-row replace),
  /// so it touches only this column — mirroring [ProjectsDao.setCompleted].
  ///
  /// This matters: [updateRow] replaces the whole row from the companion it is
  /// given, so marking sent from a stale [DbInvoice] would silently write every
  /// other column back to its old value. The send-time "mark as final" flow
  /// retypes the invoice immediately before sending it, which is exactly that
  /// case. Returns the number of rows affected (0 means no invoice matched).
  Future<int> setSent(int id) =>
      (update(invoices)..where((t) => t.id.equals(id)))
          .write(const InvoicesCompanion(isSent: Value(1)));

  Future<int> insertRow(InvoicesCompanion entry) =>
      into(invoices).insert(entry);

  Future<bool> updateRow(InvoicesCompanion entry) =>
      update(invoices).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(invoices)..where((t) => t.id.equals(id))).go();
}
