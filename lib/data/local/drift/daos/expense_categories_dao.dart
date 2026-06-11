import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/expense_categories.dart';

part 'expense_categories_dao.g.dart';

/// DAO for [ExpenseCategories].
@DriftAccessor(tables: [ExpenseCategories])
class ExpenseCategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$ExpenseCategoriesDaoMixin {
  ExpenseCategoriesDao(super.db);

  Future<List<DbExpenseCategory>> getAll() => select(expenseCategories).get();

  Stream<List<DbExpenseCategory>> watchAll() =>
      select(expenseCategories).watch();

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
