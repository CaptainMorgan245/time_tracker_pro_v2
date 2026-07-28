import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/cost_codes.dart';

part 'cost_codes_dao.g.dart';

/// DAO for [CostCodes].
@DriftAccessor(tables: [CostCodes])
class CostCodesDao extends DatabaseAccessor<AppDatabase>
    with _$CostCodesDaoMixin {
  CostCodesDao(super.db);

  /// Ordered by name, case-insensitively — see [_byName]. The cost-codes
  /// settings tab used to be the only screen that sorted this list (and the only
  /// one that did so case-insensitively); now every cost-code picker matches it.
  Future<List<DbCostCode>> getAll() => _byName().get();

  Stream<List<DbCostCode>> watchAll() => _byName().watch();

  /// `SELECT … ORDER BY name COLLATE NOCASE`.
  SimpleSelectStatement<$CostCodesTable, DbCostCode> _byName() =>
      select(costCodes)
        ..orderBy(
            [(t) => OrderingTerm(expression: t.name.collate(Collate.noCase))]);

  Future<DbCostCode?> getById(int id) =>
      (select(costCodes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertRow(CostCodesCompanion entry) =>
      into(costCodes).insert(entry);

  Future<bool> updateRow(CostCodesCompanion entry) =>
      update(costCodes).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(costCodes)..where((t) => t.id.equals(id))).go();
}
