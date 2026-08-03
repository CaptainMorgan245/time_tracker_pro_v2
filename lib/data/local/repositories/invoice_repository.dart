import '../drift/app_database.dart';
import '../drift/daos/invoices_dao.dart';

/// Thin CRUD wrapper around [InvoicesDao]. No business logic — status changes,
/// payment, and void/release orchestration live in `invoiceActionsProvider`.
class InvoiceRepository {
  InvoiceRepository(this._dao);

  final InvoicesDao _dao;

  Stream<List<DbInvoice>> watchAll() => _dao.watchAll();

  Future<DbInvoice?> getById(int id) => _dao.getById(id);

  Future<bool> update(InvoicesCompanion entry) => _dao.updateRow(entry);
}
