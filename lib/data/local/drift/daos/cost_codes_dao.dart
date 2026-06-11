import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/cost_codes.dart';

part 'cost_codes_dao.g.dart';

/// DAO for [CostCodes].
@DriftAccessor(tables: [CostCodes])
class CostCodesDao extends DatabaseAccessor<AppDatabase>
    with _$CostCodesDaoMixin {
  CostCodesDao(super.db);

  Future<List<DbCostCode>> getAll() => select(costCodes).get();

  Stream<List<DbCostCode>> watchAll() => select(costCodes).watch();

  Future<DbCostCode?> getById(int id) =>
      (select(costCodes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertRow(CostCodesCompanion entry) =>
      into(costCodes).insert(entry);

  Future<bool> updateRow(CostCodesCompanion entry) =>
      update(costCodes).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(costCodes)..where((t) => t.id.equals(id))).go();
}
