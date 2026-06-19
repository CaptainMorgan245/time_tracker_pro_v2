import 'package:drift/drift.dart';

import 'clients.dart';
import 'projects.dart';

/// Invoices. Payment state lives here as columns (`isPaid`, `amountPaid`,
/// `paymentDate`, `paymentMethod`, `paymentReference`, `paymentNotes`) — there
/// is no separate payments table. References [Clients], [Projects] and itself
/// (`supersededByInvoiceId`). Row class: `DbInvoice`.
@DataClassName('DbInvoice')
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text().unique()();
  TextColumn get invoiceDate => text()();
  IntColumn get clientId => integer().references(Clients, #id)();
  IntColumn get projectId => integer().references(Projects, #id)();
  TextColumn get projectAddress => text().nullable()();
  IntColumn get labourSubtotal => integer().withDefault(const Constant(0))();
  IntColumn get materialsSubtotal => integer().withDefault(const Constant(0))();
  IntColumn get materialsPickupCost => integer().withDefault(const Constant(0))();
  IntColumn get otherCosts => integer().withDefault(const Constant(0))();
  TextColumn get otherCostsDescription => text().nullable()();
  IntColumn get discountAmount => integer().withDefault(const Constant(0))();
  TextColumn get discountDescription => text().nullable()();
  RealColumn get discountPercent => real().withDefault(const Constant(0))();
  TextColumn get tax1Name => text().nullable()();
  RealColumn get tax1Rate => real().nullable()();
  IntColumn get tax1Amount => integer().withDefault(const Constant(0))();
  TextColumn get tax1RegistrationNumber => text().nullable()();
  TextColumn get tax2Name => text().nullable()();
  RealColumn get tax2Rate => real().nullable()();
  IntColumn get tax2Amount => integer().withDefault(const Constant(0))();
  TextColumn get tax2RegistrationNumber => text().nullable()();
  IntColumn get subtotal => integer().withDefault(const Constant(0))();
  IntColumn get totalAmount => integer().withDefault(const Constant(0))();
  TextColumn get terms =>
      text().withDefault(const Constant('Payable on Receipt'))();
  TextColumn get poNumber => text().nullable()();
  IntColumn get isPaid => integer().withDefault(const Constant(0))();
  IntColumn get amountPaid => integer().nullable()();
  TextColumn get paymentDate => text().nullable()();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get paymentReference => text().nullable()();
  TextColumn get paymentNotes => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
  TextColumn get deletedReasonCode => text().nullable()();
  TextColumn get deletedDate => text().nullable()();
  TextColumn get deletedNotes => text().nullable()();
  IntColumn get supersededByInvoiceId =>
      integer().nullable().references(Invoices, #id)();
  TextColumn get notes => text().nullable()();
  TextColumn get internalNotes => text().nullable()();
  TextColumn get workDescription => text().nullable()();
  IntColumn get isSent => integer().withDefault(const Constant(0))();
  TextColumn get invoiceType =>
      text().withDefault(const Constant('progress'))();
}
