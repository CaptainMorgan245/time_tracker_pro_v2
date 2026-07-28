import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/io/data_io_helper.dart';
import '../../data/local/repositories/backup_repository.dart';
import 'client_project_providers.dart';
import 'cost_entry_providers.dart';
import 'database_provider.dart';
import 'invoice_providers.dart';
import 'reference_data_providers.dart';
import 'time_entry_providers.dart';
// `timeEntriesStreamProvider` is also defined here (the timer lists' all-entries
// stream); aliased so both same-named providers can be invalidated.
import 'timer_providers.dart' as timer;

/// Exposes the [BackupRepository], wired to the app database.
final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  return BackupRepository(ref.watch(databaseProvider));
});

/// Drives a single import action and surfaces its lifecycle to the UI:
///
/// - `AsyncData(null)`   — idle, no import run yet
/// - `AsyncLoading`      — import in progress
/// - `AsyncData(result)` — import succeeded, [BackupImportResult] available
/// - `AsyncError`        — import failed (the database was rolled back)
class ImportController extends AsyncNotifier<BackupImportResult?> {
  @override
  FutureOr<BackupImportResult?> build() => null;

  Future<void> importFromJson(String jsonString) async {
    state = const AsyncValue.loading();
    final res = await AsyncValue.guard(
      () => ref.read(backupRepositoryProvider).importFromJsonString(jsonString),
    );
    if (!res.hasError) {
      _invalidateAll();
    }
    state = res;
  }

  void _invalidateAll() {
    // Import/clear rewrite every table via raw SQL (customStatement /
    // customInsert), which does NOT notify Drift's stream queries. So each
    // DB-backed stream must be invalidated by hand — otherwise dropdowns/lists
    // (employees, cost codes, roles, …) keep showing stale, often EMPTY data
    // until some later DAO write happens to refresh them.
    ref.invalidate(clientsStreamProvider);
    ref.invalidate(projectsStreamProvider);
    ref.invalidate(employeesStreamProvider);
    ref.invalidate(rolesStreamProvider);
    ref.invalidate(costCodesStreamProvider);
    ref.invalidate(timeEntriesStreamProvider);
    ref.invalidate(timer.timeEntriesStreamProvider);
    ref.invalidate(materialsStreamProvider);
    ref.invalidate(expenseCategoriesStreamProvider);
    ref.invalidate(appSettingsStreamProvider);
    ref.invalidate(invoicesStreamProvider);
    ref.invalidate(invoicePaymentsStreamProvider);
    ref.invalidate(companySettingsStreamProvider);
  }
}

final importControllerProvider =
    AsyncNotifierProvider.autoDispose<ImportController, BackupImportResult?>(
  ImportController.new,
);

/// Drives a single export action. On success its value is the saved file name;
/// `null` means idle OR the user dismissed the save dialog (web). Builds the
/// file name the same way the original app did (optional custom name + date,
/// else a full timestamp) and writes it via the platform [exportJsonFile]
/// helper (which prompts for a location on web/PWA).
class ExportController extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() => null;

  Future<void> export({String? customName}) async {
    final fileName = _buildFileName(customName);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // Pass the JSON builder as a callback: on web the platform helper must
      // open the save picker *before* any await (user-activation rule), so the
      // DB read only runs after a location is chosen.
      final saved = await exportJsonFile(
        fileName,
        () => ref.read(backupRepositoryProvider).exportToJsonString(),
      );
      return saved ? fileName : null;
    });
  }

  String _buildFileName(String? customName) {
    final now = DateTime.now();
    if (customName != null && customName.trim().isNotEmpty) {
      final dateOnly = DateFormat('yyyy-MM-dd').format(now);
      final sanitized = customName.trim().replaceAll(RegExp(r'[^\w\s-]'), '_');
      return 'backup_${sanitized}_$dateOnly.json';
    }
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(now);
    return 'backup_$timestamp.json';
  }
}

final exportControllerProvider =
    AsyncNotifierProvider.autoDispose<ExportController, String?>(
  ExportController.new,
);

/// Drives the destructive "clear all data" action (wipe + re-seed defaults).
/// `AsyncData(null)` idle, `AsyncLoading` in progress, `AsyncError` on failure.
class ClearDataController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> clear() async {
    state = const AsyncValue.loading();
    final res = await AsyncValue.guard(
      () => ref.read(backupRepositoryProvider).clearAllData(),
    );
    if (!res.hasError) {
      _invalidateAll();
    }
    state = res;
  }

  void _invalidateAll() {
    // Import/clear rewrite every table via raw SQL (customStatement /
    // customInsert), which does NOT notify Drift's stream queries. So each
    // DB-backed stream must be invalidated by hand — otherwise dropdowns/lists
    // (employees, cost codes, roles, …) keep showing stale, often EMPTY data
    // until some later DAO write happens to refresh them.
    ref.invalidate(clientsStreamProvider);
    ref.invalidate(projectsStreamProvider);
    ref.invalidate(employeesStreamProvider);
    ref.invalidate(rolesStreamProvider);
    ref.invalidate(costCodesStreamProvider);
    ref.invalidate(timeEntriesStreamProvider);
    ref.invalidate(timer.timeEntriesStreamProvider);
    ref.invalidate(materialsStreamProvider);
    ref.invalidate(expenseCategoriesStreamProvider);
    ref.invalidate(appSettingsStreamProvider);
    ref.invalidate(invoicesStreamProvider);
    ref.invalidate(invoicePaymentsStreamProvider);
    ref.invalidate(companySettingsStreamProvider);
  }
}

final clearDataControllerProvider =
    AsyncNotifierProvider.autoDispose<ClearDataController, void>(
  ClearDataController.new,
);
