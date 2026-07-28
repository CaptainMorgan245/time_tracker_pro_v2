import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../app_database.dart';
import '../tables/materials.dart';

part 'materials_dao.g.dart';

/// DAO for [Materials].
@DriftAccessor(tables: [Materials])
class MaterialsDao extends DatabaseAccessor<AppDatabase>
    with _$MaterialsDaoMixin {
  MaterialsDao(super.db);

  Future<List<DbMaterial>> getAll() => select(materials).get();

  Stream<List<DbMaterial>> watchAll() => select(materials).watch();

  Future<DbMaterial?> getById(int id) =>
      (select(materials)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<DbMaterial>> getByProject(int projectId) =>
      (select(materials)..where((t) => t.projectId.equals(projectId))).get();

  /// Unbilled, non-deleted materials/expenses for [projectId]. Filters
  /// `isBilled = 0 AND isDeleted = 0`. Raw feed only — the T&M `is_billable`
  /// eligibility rule is applied above this, in `invoiceableEntriesProvider`.
  Stream<List<DbMaterial>> watchUnbilledByProject(int projectId) =>
      (select(materials)
            ..where((t) =>
                t.projectId.equals(projectId) &
                t.isBilled.equals(0) &
                t.isDeleted.equals(0)))
          .watch();

  /// Amount lookup, ported from v1's `AppDatabase.searchMaterialsByAmount`:
  /// every non-deleted expense whose formatted dollar amount starts with
  /// [amountPrefix], newest first. Both the amount and the prefix are stripped
  /// of `$`/`,` before the prefix compare, so "47" matches $47.xx, $470.xx, …
  /// NB v2 stores cost in cents, so the amount is formatted as `cost / 100`.
  Future<List<DbMaterial>> searchMaterialsByAmount(String amountPrefix) async {
    final rows = await (select(materials)
          ..where((t) => t.isDeleted.equals(0))
          ..orderBy([(t) => OrderingTerm.desc(t.purchaseDate)]))
        .get();
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final normalizedPrefix = amountPrefix.replaceAll(RegExp(r'[,\$]'), '');
    return rows.where((record) {
      final formatted =
          formatter.format(record.cost / 100).replaceAll(RegExp(r'[,\$]'), '');
      return formatted.startsWith(normalizedPrefix);
    }).toList();
  }

  Future<int> insertRow(MaterialsCompanion entry) =>
      into(materials).insert(entry);

  Future<bool> updateRow(MaterialsCompanion entry) =>
      update(materials).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(materials)..where((t) => t.id.equals(id))).go();

  /// Marks the given [ids] as billed to [invoiceId] (the forward of
  /// [clearInvoiceLink]; used when an invoice is created). No-op for an empty
  /// list. Returns the number of rows updated.
  Future<int> markBilled(List<int> ids, int invoiceId) async {
    if (ids.isEmpty) return 0;
    return (update(materials)..where((t) => t.id.isIn(ids))).write(
      MaterialsCompanion(
        isBilled: const Value(1),
        invoiceId: Value(invoiceId),
      ),
    );
  }

  /// Releases all materials billed to [invoiceId] back to unbilled (used when
  /// an extras invoice is voided).
  Future<int> clearInvoiceLink(int invoiceId) =>
      (update(materials)..where((t) => t.invoiceId.equals(invoiceId)))
          .write(const MaterialsCompanion(
        isBilled: Value(0),
        invoiceId: Value(null),
      ));

  /// All materials linked to [invoiceId], as a stream — the "already on this
  /// invoice" set for the invoice-edit picker. Includes soft-deleted rows so a
  /// caller can detect a billed material that was deleted after invoicing.
  Stream<List<DbMaterial>> watchByInvoice(int invoiceId) =>
      (select(materials)..where((t) => t.invoiceId.equals(invoiceId))).watch();
}
