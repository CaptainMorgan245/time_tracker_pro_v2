import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/drift/app_database.dart';
import 'database_provider.dart';

/// Reactive list of time entries used by the dashboard timer UI.
/// (Shared dropdown data — employees, cost codes — lives in
/// `reference_data_providers.dart`.)
final timeEntriesStreamProvider = StreamProvider<List<DbTimeEntry>>((ref) {
  return ref.watch(databaseProvider).timeEntriesDao.watchAll();
});

/// The running timer currently loaded into the start form for editing, or null
/// when the form is adding. The Edit pencil on an active-timer card sets this;
/// the form listens to it to populate, and clears it on Update/Clear.
/// `autoDispose` so the selection resets when the dashboard is left.
class EditingTimerNotifier extends Notifier<DbTimeEntry?> {
  @override
  DbTimeEntry? build() => null;

  void set(DbTimeEntry? entry) => state = entry;
}

final editingTimerProvider =
    NotifierProvider.autoDispose<EditingTimerNotifier, DbTimeEntry?>(
  EditingTimerNotifier.new,
);

/// A completed/recent timer the user tapped to COPY into the start form as a
/// brand-new timer: same project + employee, with cost code and work details
/// left blank (they typically change day to day). One-shot — the form applies
/// it and resets this back to null. Distinct from [editingTimerProvider], which
/// edits an existing running entry.
class CopyTimerNotifier extends Notifier<DbTimeEntry?> {
  @override
  DbTimeEntry? build() => null;

  void set(DbTimeEntry? entry) => state = entry;
}

final copyTimerProvider =
    NotifierProvider.autoDispose<CopyTimerNotifier, DbTimeEntry?>(
  CopyTimerNotifier.new,
);

/// Start/pause/resume/stop operations for time entries, exposed as a
/// `Notifier<AsyncValue<void>>` so the UI can show progress and surface errors
/// (idle = `AsyncData(null)`; in-flight = `AsyncLoading`; failure = `AsyncError`).
/// Every write goes through `AsyncValue.guard` — no fire-and-forget.
class TimerActions extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  AppDatabase get _db => ref.read(databaseProvider);

  /// Starts a new timer. [startTime] defaults to now (the "Set Time" path
  /// passes a back-dated start). An employee is always required so the entry
  /// can be costed/invoiced/paid; [hourlyRate] is snapshotted from them.
  Future<void> start({
    required int projectId,
    required int employeeId,
    int? costCodeId,
    String? workDetails,
    double? hourlyRate,
    DateTime? startTime,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _db.timeEntriesDao.insertRow(
        TimeEntriesCompanion.insert(
          projectId: projectId,
          startTime: (startTime ?? DateTime.now()).toIso8601String(),
          employeeId: Value(employeeId),
          costCodeId: Value(costCodeId),
          workDetails: Value(workDetails),
          hourlyRate: Value(hourlyRate),
        ),
      );
    });
  }

  /// Updates a running timer's fields (Update mode). Keeps the entry active;
  /// re-snapshots the rate from the (possibly changed) employee.
  Future<void> update(
    DbTimeEntry e, {
    required int projectId,
    required int employeeId,
    int? costCodeId,
    String? workDetails,
    double? hourlyRate,
    required DateTime startTime,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _db.timeEntriesDao.updateRow(
        e.toCompanion(false).copyWith(
              projectId: Value(projectId),
              employeeId: Value(employeeId),
              costCodeId: Value(costCodeId),
              workDetails: Value(workDetails),
              hourlyRate: Value(hourlyRate),
              startTime: Value(startTime.toIso8601String()),
            ),
      );
    });
  }

  /// Pauses a running timer: records when the pause began so elapsed time can
  /// freeze. The pause length is folded into [DbTimeEntry.pausedDuration] on
  /// resume/stop.
  Future<void> pause(DbTimeEntry e) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _db.timeEntriesDao.updateRow(
        e.toCompanion(false).copyWith(
              isPaused: const Value(1),
              pauseStartTime: Value(DateTime.now().toIso8601String()),
            ),
      );
    });
  }

  Future<void> resume(DbTimeEntry e) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final paused = e.pausedDuration + _pauseSecondsSoFar(e);
      await _db.timeEntriesDao.updateRow(
        e.toCompanion(false).copyWith(
              pausedDuration: Value(paused),
              isPaused: const Value(0),
              pauseStartTime: const Value(null),
            ),
      );
    });
  }

  /// Stops a timer: sets endTime and computes billable seconds
  /// (gross elapsed minus all paused time).
  Future<void> stop(DbTimeEntry e) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final now = DateTime.now();
      final paused = e.pausedDuration + _pauseSecondsSoFar(e);
      final gross =
          now.difference(DateTime.parse(e.startTime)).inSeconds.toDouble();
      final billed = (gross - paused).clamp(0.0, double.infinity);
      await _db.timeEntriesDao.updateRow(
        e.toCompanion(false).copyWith(
              endTime: Value(now.toIso8601String()),
              pausedDuration: Value(paused),
              finalBilledDurationSeconds: Value(billed),
              isPaused: const Value(0),
              pauseStartTime: const Value(null),
            ),
      );
    });
  }

  /// Seconds elapsed in the *current* (not-yet-recorded) pause, if paused.
  double _pauseSecondsSoFar(DbTimeEntry e) {
    if (e.isPaused == 0 || e.pauseStartTime == null) return 0;
    return DateTime.now()
        .difference(DateTime.parse(e.pauseStartTime!))
        .inSeconds
        .toDouble();
  }
}

final timerActionsProvider =
    NotifierProvider.autoDispose<TimerActions, AsyncValue<void>>(
  TimerActions.new,
);
