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

  Future<int> insertRow(InvoicesCompanion entry) =>
      into(invoices).insert(entry);

  Future<bool> updateRow(InvoicesCompanion entry) =>
      update(invoices).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(invoices)..where((t) => t.id.equals(id))).go();
}
