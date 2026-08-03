import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/invoice_payments.dart';

part 'invoice_payments_dao.g.dart';

/// DAO for [InvoicePayments].
@DriftAccessor(tables: [InvoicePayments])
class InvoicePaymentsDao extends DatabaseAccessor<AppDatabase>
    with _$InvoicePaymentsDaoMixin {
  InvoicePaymentsDao(super.db);

  Stream<List<DbInvoicePayment>> watchAll() => select(invoicePayments).watch();

  Future<List<DbInvoicePayment>> getByInvoice(int invoiceId) =>
      (select(invoicePayments)..where((t) => t.invoiceId.equals(invoiceId)))
          .get();

  Future<int> insertRow(InvoicePaymentsCompanion entry) =>
      into(invoicePayments).insert(entry);

  Future<bool> updateRow(InvoicePaymentsCompanion entry) =>
      update(invoicePayments).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(invoicePayments)..where((t) => t.id.equals(id))).go();
}
