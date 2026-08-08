import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Filter state shared by every export report.
///
/// One filter object rather than one per report: a report declares which
/// dimensions it honours and the filter bar disables the rest, instead of the
/// original app's approach of a different filter layout per subject. Null always
/// means "all".
///
/// This is a UI filter notifier (same family as `timeEntryFilterProvider` /
/// `analyticsSelectionProvider`), NOT a calculation provider — it holds the
/// user's selection and nothing else.

/// Which side of the company/project divide an expense report covers.
///
/// Company expenses are stored on `materials` with `is_company_expense = 1` and
/// are filed under the internal company project, so they carry a real
/// `project_id` like any other row — the flag, not the project link, is what
/// separates them.
enum ExpenseScope {
  /// Everything — the default, and what a card/statement reconciliation needs:
  /// every charge in the period regardless of who it was for.
  all,

  /// Project expenses only (`is_company_expense = 0`).
  projectOnly,

  /// Company overhead only (`is_company_expense = 1`) — the original app's
  /// "Company Expenses" report.
  companyOnly,
}

/// The selection driving an export. Value-equal so it can key a provider family
/// later without rebuilding on every identical rebuild.
class ExportFilter {
  const ExportFilter({
    this.start,
    this.end,
    this.clientId,
    this.projectId,
    this.employeeId,
    this.costCodeId,
    this.expenseCategory,
    this.scope = ExpenseScope.all,
  });

  /// Inclusive start of the period. Null = unbounded.
  final DateTime? start;

  /// Inclusive end of the period — the whole day is included, so a row
  /// timestamped 14:32 on the end date still counts. Null = unbounded.
  final DateTime? end;

  final int? clientId;
  final int? projectId;

  /// Honoured by labour reports only; ignored by the expense report (an expense
  /// has no employee).
  final int? employeeId;

  /// `-1` means "no cost code", matching the convention already used by
  /// `TimeEntryFilter`.
  final int? costCodeId;

  /// `materials.expense_category` — the accounting bucket (Fuel, Materials, …).
  /// Deliberately distinct from `cost_codes.category`, which is the semantic
  /// classification driving project financials; conflating the two is what made
  /// the original app's billable handling ambiguous.
  final String? expenseCategory;

  final ExpenseScope scope;

  /// True when [start]/[end] land exactly on the first and last day of the same
  /// calendar month — i.e. the month quick-picker set them, not a hand-picked
  /// range. Drives the date field's label.
  bool get isWholeMonth {
    final s = start;
    final e = end;
    if (s == null || e == null) return false;
    if (s.year != e.year || s.month != e.month) return false;
    return s.day == 1 && e.day == _lastDayOfMonth(e.year, e.month);
  }

  ExportFilter copyWith({
    DateTime? Function()? start,
    DateTime? Function()? end,
    int? Function()? clientId,
    int? Function()? projectId,
    int? Function()? employeeId,
    int? Function()? costCodeId,
    String? Function()? expenseCategory,
    ExpenseScope? scope,
  }) {
    return ExportFilter(
      start: start != null ? start() : this.start,
      end: end != null ? end() : this.end,
      clientId: clientId != null ? clientId() : this.clientId,
      projectId: projectId != null ? projectId() : this.projectId,
      employeeId: employeeId != null ? employeeId() : this.employeeId,
      costCodeId: costCodeId != null ? costCodeId() : this.costCodeId,
      expenseCategory:
          expenseCategory != null ? expenseCategory() : this.expenseCategory,
      scope: scope ?? this.scope,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ExportFilter &&
      other.start == start &&
      other.end == end &&
      other.clientId == clientId &&
      other.projectId == projectId &&
      other.employeeId == employeeId &&
      other.costCodeId == costCodeId &&
      other.expenseCategory == expenseCategory &&
      other.scope == scope;

  @override
  int get hashCode => Object.hash(start, end, clientId, projectId, employeeId,
      costCodeId, expenseCategory, scope);
}

class ExportFilterNotifier extends Notifier<ExportFilter> {
  /// Opens on the **current calendar month**, snapped to its bounds.
  ///
  /// Deliberately not the Jan-1→today default the records screens use: the
  /// driving job here is reconciling a card statement, which is a month. Future
  /// dates can't occur (the entry forms cap the date picker at today), so
  /// snapping to the full month rather than month-to-date costs nothing and
  /// keeps the default consistent with what the month picker produces.
  @override
  ExportFilter build() {
    final now = DateTime.now();
    return ExportFilter(
      start: _monthStart(now.year, now.month),
      end: _monthEnd(now.year, now.month),
    );
  }

  void setStart(DateTime? d) => state = state.copyWith(start: () => d);
  void setEnd(DateTime? d) => state = state.copyWith(end: () => d);

  /// Snaps the range to the calendar month containing [anyDayInMonth].
  void setMonth(DateTime anyDayInMonth) {
    state = state.copyWith(
      start: () => _monthStart(anyDayInMonth.year, anyDayInMonth.month),
      end: () => _monthEnd(anyDayInMonth.year, anyDayInMonth.month),
    );
  }

  /// Steps the selected month by [delta] months (−1 = previous, +1 = next).
  /// Anchors off [ExportFilter.start] when there is one, else today.
  void stepMonth(int delta) {
    final anchor = state.start ?? DateTime.now();
    // DateTime normalises an out-of-range month, so month 0 → December of the
    // previous year and month 13 → January of the next.
    setMonth(DateTime(anchor.year, anchor.month + delta, 1));
  }

  /// Changing the client clears the project — the project list is client-scoped,
  /// same rule as `TimeEntryFilterNotifier.setClient`.
  void setClient(int? id) =>
      state = state.copyWith(clientId: () => id, projectId: () => null);

  void setProject(int? id) => state = state.copyWith(projectId: () => id);
  void setEmployee(int? id) => state = state.copyWith(employeeId: () => id);
  void setCostCode(int? id) => state = state.copyWith(costCodeId: () => id);
  void setExpenseCategory(String? c) =>
      state = state.copyWith(expenseCategory: () => c);
  void setScope(ExpenseScope s) => state = state.copyWith(scope: s);

  /// Clears every dimension except the date range and applies [scope] — how the
  /// report presets ("All Expenses", "Company Expenses") seed the filter without
  /// disturbing the period the user is already looking at.
  void applyPreset(ExpenseScope scope) {
    state = ExportFilter(
      start: state.start,
      end: state.end,
      scope: scope,
    );
  }
}

final exportFilterProvider =
    NotifierProvider<ExportFilterNotifier, ExportFilter>(
  ExportFilterNotifier.new,
);

DateTime _monthStart(int year, int month) => DateTime(year, month, 1);

/// Last instant that still belongs to the month — day 0 of the *next* month is
/// the last day of this one.
DateTime _monthEnd(int year, int month) =>
    DateTime(year, month + 1, 0, 23, 59, 59);

int _lastDayOfMonth(int year, int month) => DateTime(year, month + 1, 0).day;
