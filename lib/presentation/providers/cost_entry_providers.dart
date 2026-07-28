import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/drift/app_database.dart';
import 'database_provider.dart';

/// Reactive list of all materials/expenses. Auto-updates on any `materials`
/// table change.
final materialsStreamProvider = StreamProvider<List<DbMaterial>>((ref) {
  return ref.watch(databaseProvider).materialsDao.watchAll();
});

/// Amount-lookup query for the Cost Entry tab (ported from v1). Empty = inactive
/// (the records list shows the normal client/project-scoped expenses); non-empty
/// = the list switches to a lookup across ALL non-deleted expenses whose
/// formatted dollar amount starts with this text. Written by the dashboard
/// app-bar search field, read by [CostEntryScreen].
class CostEntryAmountSearch extends Notifier<String> {
  @override
  String build() => '';

  void set(String query) => state = query;
  void clear() => state = '';
}

final costEntryAmountSearchProvider =
    NotifierProvider<CostEntryAmountSearch, String>(CostEntryAmountSearch.new);

/// Results of the Cost Entry amount lookup for [query], via the DAO's ported v1
/// `searchMaterialsByAmount`. Re-runs when the query or the materials table
/// changes (the `watch` keeps the list live as expenses are added/edited/
/// deleted — v1 refreshed the same way via its refresh key).
final materialsByAmountProvider = FutureProvider.autoDispose
    .family<List<DbMaterial>, String>((ref, query) {
  ref.watch(materialsStreamProvider);
  return ref.read(databaseProvider).materialsDao.searchMaterialsByAmount(query);
});

/// Raw unbilled, non-deleted materials/expenses for a project, keyed by
/// projectId. Base feed only — it does NOT apply the T&M `is_billable` rule. For
/// invoice selection use `invoiceableEntriesProvider` (in
/// invoice_providers.dart), which filters this to billable-coded materials.
final unbilledMaterialsProvider =
    StreamProvider.family<List<DbMaterial>, int>((ref, projectId) {
  return ref
      .watch(databaseProvider)
      .materialsDao
      .watchUnbilledByProject(projectId);
});

/// Reactive list of expense categories (own table).
final expenseCategoriesStreamProvider =
    StreamProvider<List<DbExpenseCategory>>((ref) {
  return ref.watch(databaseProvider).expenseCategoriesDao.watchAll();
});

/// The single app-settings row (id == 1). Vendors and vehicle designations are
/// comma-joined strings on this row (see [splitCsv]).
final appSettingsStreamProvider = StreamProvider<DbSetting?>((ref) {
  return ref.watch(databaseProvider).settingsDao.watchSettings();
});

/// Splits a comma-joined settings string (vendors / vehicleDesignations) into a
/// trimmed, non-empty list, **sorted case-insensitively**. Mirrors the Expenses
/// settings tab encoding.
///
/// Vendors and vehicle designations are stored as ONE CSV string on the settings
/// row, not as tables, so unlike the six reference DAOs there is no `ORDER BY`
/// for callers to inherit — the sort has to live here. Doing it here covers all
/// three consumers at once: the Settings > Expenses editor and the vendor
/// pickers on the cost-entry and edit-expense forms.
///
/// Safe for the Settings tab's index-based edit/delete: that screen mutates the
/// same list it renders, so a displayed index always refers to the entry shown.
/// One visible consequence — saving after an edit rewrites the stored CSV in
/// sorted order.
List<String> splitCsv(String? csv) => (csv ?? '')
    .split(',')
    .map((s) => s.trim())
    .where((s) => s.isNotEmpty)
    .toList()
  ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

/// Add/update/delete operations for materials/expenses, exposed as a
/// `Notifier<AsyncValue<void>>` so the UI can show progress and surface errors
/// (idle = `AsyncData(null)`). Every write goes through `AsyncValue.guard`.
class CostEntryActions extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  AppDatabase get _db => ref.read(databaseProvider);

  /// Inserts a new expense. Pass a `MaterialsCompanion.insert(...)`.
  Future<void> add(MaterialsCompanion entry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _db.materialsDao.insertRow(entry);
    });
  }

  /// Replaces an existing expense. Pass a full companion built from
  /// `row.toCompanion(false).copyWith(...)` so every column is preserved.
  Future<void> update(MaterialsCompanion entry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _db.materialsDao.updateRow(entry);
    });
  }

  Future<void> delete(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _db.materialsDao.deleteById(id);
    });
  }
}

final costEntryActionsProvider =
    NotifierProvider.autoDispose<CostEntryActions, AsyncValue<void>>(
  CostEntryActions.new,
);
