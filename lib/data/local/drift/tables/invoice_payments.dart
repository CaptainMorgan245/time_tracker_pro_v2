import 'package:drift/drift.dart';

import 'invoices.dart';

/// Individual payments recorded against an [Invoices] row. Replaces the former
/// single-payment columns on `Invoices` (`isPaid`, `amountPaid`, `paymentDate`,
/// `paymentMethod`, `paymentReference`, `paymentNotes`) with a one-to-many model
/// so an invoice can be paid in instalments. Money (`amount`) is integer cents,
/// consistent with the rest of the schema. Voided payments are kept (soft-void)
/// for audit and excluded from paid-amount rollups: an invoice's amount paid is
/// `SUM(amount) WHERE invoiceId = ? AND isVoid = 0`.
/// Row class: `DbInvoicePayment`.
@DataClassName('DbInvoicePayment')
@TableIndex(name: 'idx_invoice_payments_invoice', columns: {#invoiceId})
class InvoicePayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().references(Invoices, #id)();

  /// Payment amount in cents.
  IntColumn get amount => integer()();

  TextColumn get paymentDate => text()(); // ISO-8601 string
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get paymentReference => text().nullable()();
  TextColumn get paymentNotes => text().nullable()();

  // Soft-void support (mirrors the invoice deleted* pattern).
  IntColumn get isVoid => integer().withDefault(const Constant(0))();
  TextColumn get voidReasonCode => text().nullable()();
  TextColumn get voidDate => text().nullable()();
  TextColumn get voidNotes => text().nullable()();

  TextColumn get createdAt => text()(); // ISO-8601 string
}
