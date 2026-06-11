import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/repositories/backup_import_repository.dart';
import 'database_provider.dart';

/// Exposes the [BackupImportRepository], wired to the app database.
final backupImportRepositoryProvider = Provider<BackupImportRepository>((ref) {
  return BackupImportRepository(ref.watch(databaseProvider));
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
    state = await AsyncValue.guard(
      () => ref.read(backupImportRepositoryProvider).importFromJsonString(
            jsonString,
          ),
    );
  }
}

final importControllerProvider =
    AsyncNotifierProvider.autoDispose<ImportController, BackupImportResult?>(
  ImportController.new,
);
