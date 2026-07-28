import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/expense_categories.dart';

part 'expense_categories_dao.g.dart';

/// DAO for [ExpenseCategories].
@DriftAccessor(tables: [ExpenseCategories])
class ExpenseCategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$ExpenseCategoriesDaoMixin {
  ExpenseCategoriesDao(super.db);

  /// Ordered by name, case-insensitively — see [_byName].
  Future<List<DbExpenseCategory>> getAll() => _byName().get();

  Stream<List<DbExpenseCategory>> watchAll() => _byName().watch();

  /// `SELECT … ORDER BY name COLLATE NOCASE`, so every category picker and list
  /// is alphabetical without each screen sorting for itself.
  SimpleSelectStatement<$ExpenseCategoriesTable, DbExpenseCategory> _byName() =>
      select(expenseCategories)
        ..orderBy(
            [(t) => OrderingTerm(expression: t.name.collate(Collate.noCase))]);

  Future<DbExpenseCategory?> getById(int id) =>
      (select(expenseCategories)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertRow(ExpenseCategoriesCompanion entry) =>
      into(expenseCategories).insert(entry);

  Future<bool> updateRow(ExpenseCategoriesCompanion entry) =>
      update(expenseCategories).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(expenseCategories)..where((t) => t.id.equals(id))).go();
}
