import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/drift/app_database.dart';
import 'database_provider.dart';
import 'reference_data_providers.dart';
import 'time_entry_providers.dart';

/// Payroll module — provider layer only (no UI).
///
/// The model is intentionally simple and **company-wide**:
///   balance = earned − paid, per employee.
/// - `earned` = Σ (billed seconds / 3600 × `employees.hourly_rate`), in cents.
/// - `paid`   = Σ non-filtered `worker_payments.amount`, in cents.
/// - A payment's `project_id` is record-keeping only; it never affects a
///   balance. There is no forgiveness / write-off / profitability capping and no
///   owner/calculated-vs-actual tracking.
///
/// All money is in integer **cents**. Hours/earned use the raw billed duration
/// (no settings time-rounding). The two selection flows are kept separate at the
/// notifier level; the calculation providers are pure families keyed by value
/// objects, so either flow can drive them.

// ===========================================================================
// Value objects / models
// ===========================================================================

/// Inclusive date window. Value-equal so it's a stable family key.
class PayrollDateRange {
  const PayrollDateRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;

  @override
  bool operator ==(Object other) =>
      other is PayrollDateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// Date window + optional project filter. Value-equal so it's a stable family
/// key for the earnings/payments providers.
class PayrollQuery {
  const PayrollQuery({required this.start, required this.end, this.projectId});
  final DateTime start;
  final DateTime end;
  final int? projectId;

  PayrollDateRange get dateRange =>
      PayrollDateRange(start: start, end: end);

  @override
  bool operator ==(Object other) =>
      other is PayrollQuery &&
      other.start == start &&
      other.end == end &&
      other.projectId == projectId;

  @override
  int get hashCode => Object.hash(start, end, projectId);
}

/// Earnings for one employee over a query window.
class EmployeeEarnings {
  const EmployeeEarnings({
    required this.employeeId,
    required this.employeeName,
    required this.hours,
    required this.earnedCents,
  });
  final int employeeId;
  final String employeeName;
  final double hours;
  final int earnedCents;
}

/// One per-employee payroll row: earned, paid, and the derived balance.
class PayrollSummaryRow {
  const PayrollSummaryRow({
    required this.employeeId,
    required this.employeeName,
    required this.hours,
    required this.earnedCents,
    required this.paidCents,
  });
  final int employeeId;
  final String employeeName;
  final double hours;
  final int earnedCents;
  final int paidCents;

  /// Company-wide balance — positive means still owed to the employee.
  int get balanceCents => earnedCents - paidCents;
}

// ===========================================================================
// Selection notifier (single date-range flow)
// ===========================================================================

/// The one selection that drives the Project Disbursements view: a date window.
/// Defaults to the current year (Jan 1 → today) so the view opens on YTD
/// running totals; narrowing it filters both the totals and the payment history.
class PayrollRangeNotifier extends Notifier<PayrollDateRange> {
  @override
  PayrollDateRange build() {
    final now = DateTime.now();
    return PayrollDateRange(start: DateTime(now.year, 1, 1), end: now);
  }

  void setStart(DateTime start) =>
      state = PayrollDateRange(start: start, end: state.end);
  void setEnd(DateTime end) =>
      state = PayrollDateRange(start: state.start, end: end);
}

final payrollRangeProvider =
    NotifierProvider<PayrollRangeNotifier, PayrollDateRange>(
  PayrollRangeNotifier.new,
);

// ===========================================================================
// Core data providers
// ===========================================================================

/// Earnings per employee for [query]: hours and earned cents from completed,
/// non-deleted time entries (rate = `employees.hourly_rate`), date-filtered by
/// `start_time` and optionally restricted to `query.projectId`. Emits a row for
/// every non-deleted employee, including those with no time in the period.
final payrollEarningsProvider =
    FutureProvider.family<List<EmployeeEarnings>, PayrollQuery>(
        (ref, query) async {
  final entries = await ref.watch(timeEntriesStreamProvider.future);
  final employees = await ref.watch(employeesStreamProvider.future);

  final startBound =
      DateTime(query.start.year, query.start.month, query.start.day);
  final endBound =
      DateTime(query.end.year, query.end.month, query.end.day, 23, 59, 59);

  final rateById = {for (final e in employees) e.id: e.hourlyRate ?? 0};
  final hoursById = <int, double>{};
  final earnedById = <int, double>{}; // accumulate in cents, round at the end

  for (final t in entries) {
    final empId = t.employeeId;
    if (empId == null) continue;
    if (query.projectId != null && t.projectId != query.projectId) continue;
    final start = DateTime.tryParse(t.startTime);
    if (start == null) continue;
    if (start.isBefore(startBound) || start.isAfter(endBound)) continue;

    final hours = (t.finalBilledDurationSeconds ?? 0).toDouble() / 3600.0;
    hoursById[empId] = (hoursById[empId] ?? 0) + hours;
    earnedById[empId] = (earnedById[empId] ?? 0) + hours * (rateById[empId] ?? 0);
  }

  final result = <EmployeeEarnings>[
    for (final e in employees)
      if (e.isDeleted == 0)
        EmployeeEarnings(
          employeeId: e.id,
          employeeName: e.name,
          hours: hoursById[e.id] ?? 0,
          earnedCents: (earnedById[e.id] ?? 0).round(),
        ),
  ]..sort((a, b) => a.employeeName.compareTo(b.employeeName));
  return result;
});

/// `worker_payments` for [query]: date-filtered by `payment_date`, optionally
/// restricted to `query.projectId`, newest first. This is the record-keeping
/// list view; the balance in [payrollSummaryProvider] does NOT use the project
/// filter.
final payrollPaymentsProvider =
    StreamProvider.family<List<DbWorkerPayment>, PayrollQuery>((ref, query) {
  final startBound =
      DateTime(query.start.year, query.start.month, query.start.day);
  final endBound =
      DateTime(query.end.year, query.end.month, query.end.day, 23, 59, 59);

  return ref.watch(databaseProvider).workerPaymentsDao.watchAll().map((all) {
    return all.where((p) {
      if (query.projectId != null && p.projectId != query.projectId) {
        return false;
      }
      final d = DateTime.tryParse(p.paymentDate);
      if (d == null) return false;
      return !d.isBefore(startBound) && !d.isAfter(endBound);
    }).toList()
      ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  });
});

/// Per-employee payroll summary (earned, paid, balance) over [range], **company
/// wide**: the project filter is intentionally not applied — a payment's project
/// link never affects the balance.
final payrollSummaryProvider =
    FutureProvider.family<List<PayrollSummaryRow>, PayrollDateRange>(
        (ref, range) async {
  final query = PayrollQuery(start: range.start, end: range.end); // no project
  final earnings = await ref.watch(payrollEarningsProvider(query).future);
  final payments = await ref.watch(payrollPaymentsProvider(query).future);

  final paidById = <int, int>{};
  for (final p in payments) {
    paidById[p.employeeId] = (paidById[p.employeeId] ?? 0) + p.amount;
  }

  return [
    for (final e in earnings)
      PayrollSummaryRow(
        employeeId: e.employeeId,
        employeeName: e.employeeName,
        hours: e.hours,
        earnedCents: e.earnedCents,
        paidCents: paidById[e.employeeId] ?? 0,
      ),
  ];
});

// ===========================================================================
// Actions (create / update / delete worker_payments)
// ===========================================================================

/// Mutations for `worker_payments`. Idle = `AsyncData(null)`; every write runs
/// through `AsyncValue.guard`. The wage/dividend distinction was removed, so
/// callers no longer pass a payment type; the NOT NULL `payment_type` column is
/// satisfied with a fixed [_kPaymentType] (kept to avoid a schema change).
class PayrollActions extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  AppDatabase get _db => ref.read(databaseProvider);

  /// Fixed value written to the NOT-NULL `payment_type` column now that the
  /// wage/dividend distinction is gone. The column stays in the schema.
  static const String _kPaymentType = 'wage';

  Future<void> addPayment({
    required int employeeId,
    required int amountCents,
    required DateTime paymentDate,
    int? projectId,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _db.workerPaymentsDao.insertRow(
        WorkerPaymentsCompanion.insert(
          employeeId: employeeId,
          projectId: Value(projectId),
          paymentDate: paymentDate.toIso8601String(),
          amount: amountCents,
          paymentType: _kPaymentType,
          note: Value(note),
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
    });
  }

  /// Replaces an existing payment. [createdAt] preserves the original creation
  /// timestamp (pass the existing row's value).
  Future<void> updatePayment({
    required int id,
    required int employeeId,
    required int amountCents,
    required DateTime paymentDate,
    required String createdAt,
    int? projectId,
    String? note,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _db.workerPaymentsDao.updateRow(
        WorkerPaymentsCompanion(
          id: Value(id),
          employeeId: Value(employeeId),
          projectId: Value(projectId),
          paymentDate: Value(paymentDate.toIso8601String()),
          amount: Value(amountCents),
          paymentType: const Value(_kPaymentType),
          note: Value(note),
          createdAt: Value(createdAt),
        ),
      );
    });
  }

  Future<void> deletePayment(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _db.workerPaymentsDao.deleteById(id));
  }
}

final payrollActionsProvider =
    NotifierProvider<PayrollActions, AsyncValue<void>>(PayrollActions.new);
