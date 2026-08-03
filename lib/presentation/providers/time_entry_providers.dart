import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/billing_calc.dart';
import '../../data/local/drift/app_database.dart';
import '../../data/local/repositories/time_entry_repository.dart';
import 'client_project_providers.dart';
import 'cost_entry_providers.dart';
import 'database_provider.dart';
import 'reference_data_providers.dart';

/// Thin CRUD repository over the time-entries DAO.
final timeEntryRepositoryProvider = Provider<TimeEntryRepository>((ref) {
  return TimeEntryRepository(ref.watch(databaseProvider).timeEntriesDao);
});

/// Reactive list of completed, non-deleted time entries for the records list.
/// Backed by the DAO's `watchCompleted()` stream, so it auto-updates on any
/// `time_entries` table change.
final timeEntriesStreamProvider = StreamProvider<List<DbTimeEntry>>((ref) {
  return ref.watch(timeEntryRepositoryProvider).watchCompleted();
});

/// Raw unbilled, completed, non-deleted time entries for a project, keyed by
/// projectId. This is the base feed only — it does NOT apply the T&M
/// `is_billable` rule. For invoice selection use `invoiceableEntriesProvider`
/// (in invoice_providers.dart), which filters this to billable-coded entries.
final unbilledTimeEntriesProvider =
    StreamProvider.family<List<DbTimeEntry>, int>((ref, projectId) {
  return ref
      .watch(timeEntryRepositoryProvider)
      .watchUnbilledByProject(projectId);
});

/// Add/update/delete operations for time entries, exposed as a
/// `Notifier<AsyncValue<void>>` so the UI can show progress and surface errors
/// (idle = `AsyncData(null)`). Every write goes through `AsyncValue.guard` and
/// invalidates [timeEntriesStreamProvider] on completion.
///
/// This is also where the billed-duration calc lives: `add`/`update` derive
/// `finalBilledDurationSeconds` from the companion's start/end and apply the
/// settings time-rounding interval, mirroring the original app's
/// `_applyTimeRounding`. The form passes start/end on the companion and the
/// derived value is computed here.
class TimeEntryActions extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  TimeEntryRepository get _repo => ref.read(timeEntryRepositoryProvider);

  Future<void> add(TimeEntriesCompanion entry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.insertRow(await _withBilledDuration(entry));
    });
    ref.invalidate(timeEntriesStreamProvider);
  }

  Future<void> update(TimeEntriesCompanion entry) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.updateRow(await _withBilledDuration(entry));
    });
    ref.invalidate(timeEntriesStreamProvider);
  }

  Future<void> delete(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.softDelete(id);
    });
    ref.invalidate(timeEntriesStreamProvider);
  }

  /// Returns [entry] with `finalBilledDurationSeconds` derived from its start
  /// and end times, rounded to the settings interval. If either timestamp is
  /// missing or unparseable, the entry is returned unchanged.
  Future<TimeEntriesCompanion> _withBilledDuration(
      TimeEntriesCompanion entry) async {
    if (!entry.startTime.present || !entry.endTime.present) return entry;
    final start = DateTime.tryParse(entry.startTime.value);
    final endRaw = entry.endTime.value;
    final end = endRaw == null ? null : DateTime.tryParse(endRaw);
    if (start == null || end == null) return entry;

    final seconds = end.difference(start).inSeconds.toDouble();
    final settings = await ref.read(databaseProvider).settingsDao.getSettings();
    final rounded = _applyTimeRounding(seconds, settings?.timeRoundingInterval);
    return entry.copyWith(finalBilledDurationSeconds: Value(rounded));
  }

  /// Rounds [seconds] to the nearest [intervalMinutes] boundary. A null or zero
  /// interval means no rounding. Mirrors the original app's `_applyTimeRounding`.
  double _applyTimeRounding(double seconds, int? intervalMinutes) {
    if (intervalMinutes == null || intervalMinutes == 0) return seconds;
    final intervalSeconds = intervalMinutes * 60;
    return (seconds / intervalSeconds).round() * intervalSeconds.toDouble();
  }
}

final timeEntryActionsProvider =
    NotifierProvider.autoDispose<TimeEntryActions, AsyncValue<void>>(
  TimeEntryActions.new,
);

// ---------------------------------------------------------------------------
// Filter state + derived data for the Time Entry records screen.
// ---------------------------------------------------------------------------

/// Filter selections for the records list. Null means "all"; `costCodeId == -1`
/// means "No Cost Code". Dates default to Jan 1 of the current year → today.
class TimeEntryFilter {
  const TimeEntryFilter({
    this.startDate,
    this.endDate,
    this.clientId,
    this.projectId,
    this.employeeId,
    this.costCodeId,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final int? clientId;
  final int? projectId;
  final int? employeeId;
  final int? costCodeId;

  TimeEntryFilter copyWith({
    DateTime? Function()? startDate,
    DateTime? Function()? endDate,
    int? Function()? clientId,
    int? Function()? projectId,
    int? Function()? employeeId,
    int? Function()? costCodeId,
  }) {
    return TimeEntryFilter(
      startDate: startDate != null ? startDate() : this.startDate,
      endDate: endDate != null ? endDate() : this.endDate,
      clientId: clientId != null ? clientId() : this.clientId,
      projectId: projectId != null ? projectId() : this.projectId,
      employeeId: employeeId != null ? employeeId() : this.employeeId,
      costCodeId: costCodeId != null ? costCodeId() : this.costCodeId,
    );
  }
}

class TimeEntryFilterNotifier extends Notifier<TimeEntryFilter> {
  @override
  TimeEntryFilter build() {
    final now = DateTime.now();
    return TimeEntryFilter(startDate: DateTime(now.year, 1, 1), endDate: now);
  }

  void setStartDate(DateTime? d) => state = state.copyWith(startDate: () => d);
  void setEndDate(DateTime? d) => state = state.copyWith(endDate: () => d);

  /// Changing the client clears the project (the project list is client-scoped).
  void setClient(int? id) =>
      state = state.copyWith(clientId: () => id, projectId: () => null);
  void setProject(int? id) => state = state.copyWith(projectId: () => id);
  void setEmployee(int? id) => state = state.copyWith(employeeId: () => id);
  void setCostCode(int? id) => state = state.copyWith(costCodeId: () => id);
}

final timeEntryFilterProvider =
    NotifierProvider<TimeEntryFilterNotifier, TimeEntryFilter>(
  TimeEntryFilterNotifier.new,
);

/// A fully-resolved row for the records list: the entry plus display names and
/// computed hours/value, so the screen renders without doing any lookups.
class TimeEntryRow {
  const TimeEntryRow({
    required this.entry,
    required this.startTime,
    required this.projectName,
    required this.clientName,
    required this.costCodeName,
    required this.employeeName,
    required this.hours,
    required this.value,
  });

  final DbTimeEntry entry;
  final DateTime? startTime;
  final String projectName;
  final String clientName;
  final String costCodeName;
  final String employeeName;
  final double hours;
  final double value;
}

/// The records list after filtering + rate/value computation. Combines the
/// completed time entries with all reference data and the active
/// [timeEntryFilterProvider]. Order follows [timeEntriesStreamProvider]
/// (newest first).
final timeEntryRowsProvider = Provider<AsyncValue<List<TimeEntryRow>>>((ref) {
  final entriesA = ref.watch(timeEntriesStreamProvider);
  final projectsA = ref.watch(projectsStreamProvider);
  final clientsA = ref.watch(clientsStreamProvider);
  final employeesA = ref.watch(employeesStreamProvider);
  final costCodesA = ref.watch(costCodesStreamProvider);
  final rolesA = ref.watch(rolesStreamProvider);
  final settingsA = ref.watch(appSettingsStreamProvider);
  final filter = ref.watch(timeEntryFilterProvider);

  return _combine(
    [entriesA, projectsA, clientsA, employeesA, costCodesA, rolesA, settingsA],
    () => _buildRows(
      entries: entriesA.requireValue,
      projects: projectsA.requireValue,
      clients: clientsA.requireValue,
      employees: employeesA.requireValue,
      costCodes: costCodesA.requireValue,
      roles: rolesA.requireValue,
      companyDefaultRateCents: settingsA.requireValue?.companyHourlyRate,
      filter: filter,
    ),
  );
});

/// Totals over the filtered rows (Records / Hours / Value summary line).
class TimeEntrySummary {
  const TimeEntrySummary({
    required this.recordCount,
    required this.totalHours,
    required this.totalValue,
  });

  final int recordCount;
  final double totalHours;
  final double totalValue;
}

final timeEntrySummaryProvider = Provider<AsyncValue<TimeEntrySummary>>((ref) {
  return ref.watch(timeEntryRowsProvider).whenData(
        (rows) => TimeEntrySummary(
          recordCount: rows.length,
          totalHours: rows.fold(0.0, (s, r) => s + r.hours),
          totalValue: rows.fold(0.0, (s, r) => s + r.value),
        ),
      );
});

// ---- internal derivation helpers ------------------------------------------

/// Combines several [AsyncValue]s: propagates the first error, stays loading
/// until all have a value, then builds the result.
AsyncValue<R> _combine<R>(
    List<AsyncValue<Object?>> values, R Function() build) {
  for (final v in values) {
    if (v.hasError) {
      return AsyncValue.error(v.error!, v.stackTrace ?? StackTrace.current);
    }
  }
  if (values.any((v) => !v.hasValue)) return AsyncValue<R>.loading();
  return AsyncValue.data(build());
}

List<TimeEntryRow> _buildRows({
  required List<DbTimeEntry> entries,
  required List<DbProject> projects,
  required List<DbClient> clients,
  required List<DbEmployee> employees,
  required List<DbCostCode> costCodes,
  required List<DbRole> roles,
  required int? companyDefaultRateCents,
  required TimeEntryFilter filter,
}) {
  final projectById = {for (final p in projects) p.id: p};
  final clientById = {for (final c in clients) c.id: c};
  final employeeById = {for (final e in employees) e.id: e};
  final costCodeById = {for (final c in costCodes) c.id: c};
  final roleById = {for (final r in roles) r.id: r};

  final rows = <TimeEntryRow>[];
  for (final e in entries) {
    final start = DateTime.tryParse(e.startTime);
    if (start == null) continue;
    if (filter.startDate != null && start.isBefore(filter.startDate!)) continue;
    if (filter.endDate != null &&
        start.isAfter(filter.endDate!.add(const Duration(days: 1)))) {
      continue;
    }

    final project = projectById[e.projectId];
    if (project == null || project.isCompleted != 0) continue;

    if (filter.employeeId != null && e.employeeId != filter.employeeId) {
      continue;
    }
    if (filter.costCodeId != null) {
      if (filter.costCodeId == -1) {
        if (e.costCodeId != null) continue;
      } else if (e.costCodeId != filter.costCodeId) {
        continue;
      }
    }
    if (filter.projectId != null && e.projectId != filter.projectId) continue;
    if (filter.clientId != null && project.clientId != filter.clientId) {
      continue;
    }

    final billedSeconds = (e.finalBilledDurationSeconds ?? 0).toDouble();
    final hours = billedSeconds / 3600;
    final rateCents = hourlyRateCents(
      project,
      e.employeeId,
      employeeById,
      roleById,
      companyDefaultRateCents: companyDefaultRateCents,
    );
    rows.add(TimeEntryRow(
      entry: e,
      startTime: start,
      projectName: project.projectName,
      clientName: clientById[project.clientId]?.name ?? 'Unknown',
      costCodeName: e.costCodeId == null
          ? 'No Cost Code'
          : (costCodeById[e.costCodeId]?.name ?? 'Unknown'),
      employeeName: e.employeeId == null
          ? 'N/A'
          : (employeeById[e.employeeId]?.name ?? 'Unknown'),
      hours: hours,
      value: labourValueCents(rateCents, billedSeconds) / 100,
    ));
  }
  return rows;
}
