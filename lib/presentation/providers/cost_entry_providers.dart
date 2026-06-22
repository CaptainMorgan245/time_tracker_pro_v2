import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/drift/app_database.dart';
import 'database_provider.dart';

/// Reactive list of all materials/expenses. Auto-updates on any `materials`
/// table change.
final materialsStreamProvider = StreamProvider<List<DbMaterial>>((ref) {
  return ref.watch(databaseProvider).materialsDao.watchAll();
});

/// Unbilled, non-deleted materials/expenses for a project — the candidate lines
/// for a new invoice (Phase 2). Keyed by projectId. Use this for invoice
/// selection rather than [materialsStreamProvider], which is unfiltered
/// (includes deleted and already-billed rows).
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
/// trimmed, non-empty list. Mirrors the Expenses settings tab encoding.
List<String> splitCsv(String? csv) => (csv ?? '')
    .split(',')
    .map((s) => s.trim())
    .where((s) => s.isNotEmpty)
    .toList();

/// The expense currently loaded into the inline cost-entry form for editing, or
/// null when adding. The list's Edit icon sets this; the form listens to it to
/// populate, and clears it on save/clear. `autoDispose` so the selection resets
/// when the Cost Entry tab is left.
class EditingMaterialNotifier extends Notifier<DbMaterial?> {
  @override
  DbMaterial? build() => null;

  void set(DbMaterial? material) => state = material;
}

final editingMaterialProvider =
    NotifierProvider.autoDispose<EditingMaterialNotifier, DbMaterial?>(
  EditingMaterialNotifier.new,
);

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
