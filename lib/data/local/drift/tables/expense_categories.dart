import 'package:drift/drift.dart';

/// Expense categories for materials/expenses. Row class: `DbExpenseCategory`.
@DataClassName('DbExpenseCategory')
class ExpenseCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}
