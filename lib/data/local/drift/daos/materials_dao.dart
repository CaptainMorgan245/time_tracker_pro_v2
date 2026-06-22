import 'package:drift/drift.dart';

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

  /// Unbilled, non-deleted materials/expenses for [projectId] — the candidates
  /// for a new invoice. Filters `isBilled = 0 AND isDeleted = 0`.
  Stream<List<DbMaterial>> watchUnbilledByProject(int projectId) =>
      (select(materials)
            ..where((t) =>
                t.projectId.equals(projectId) &
                t.isBilled.equals(0) &
                t.isDeleted.equals(0)))
          .watch();

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
}
