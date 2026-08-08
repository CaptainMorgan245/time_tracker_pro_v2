import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/invoice_calc.dart';
import '../../data/local/drift/app_database.dart';
import 'async_combine.dart';
import 'client_project_providers.dart';
import 'cost_entry_providers.dart';
import 'invoice_providers.dart';

/// **Client and project statements** — the client-facing financial history,
/// distinct from an invoice.
///
/// A statement answers "what has this client been billed, and what have they
/// paid" — NOT "does this reconcile against the contract". That distinction
/// drives the one rule that separates this file from the contract math in
/// `final_invoice_providers.dart`:
///
/// > **Every** non-deleted invoice on the project counts, regardless of
/// > `invoiceType` — including `'extras'`.
///
/// `contractInvoiceTypes` deliberately excludes `'extras'` so above-contract
/// work can't consume a fixed-price contract's balance. A statement has the
/// opposite requirement: billable work beyond the fixed price is real money the
/// client owes, so a fixed-price project's Total Billed legitimately exceeds its
/// contract amount, and "Paid in Full" requires the extras paid too.
///
/// Money is integer **cents** throughout, and billed amounts are
/// `invoices.totalAmount` (tax-inclusive) — what the client was actually asked
/// to pay.
///
/// ## Status is completion + payment, nothing else
///
/// The same corollary governs whether a project reads as closed. A completed
/// project whose invoices are all paid is "Paid in Full" — with no requirement
/// for a `'final'`-typed invoice and no check that total billed matches
/// `project_price`. Contracts are routinely settled for less than their price
/// through deliberate discounts and write-offs, and none of that should hold a
/// project open. Identical rule for fixed-price and T&M; see [_projectStatus].
///
/// ## Windowed vs lifetime
///
/// The client statement's date filter windows the **ledger and its subtotals
/// only**. Project status and the balance-owing figure are ALWAYS computed over
/// the project's full lifetime, because whether a project is paid off is a fact
/// about the project, not about the window you happen to be viewing. (v1's
/// `StatementRepository` derived its fixed-price balance from the *windowed*
/// billed amount, and its own comment conceded the figure was only meaningful
/// with no filter set — that behaviour is deliberately not ported.)

// ---------------------------------------------------------------------------
// Read model
// ---------------------------------------------------------------------------

/// Payment state of a single ledger line.
enum LedgerLineStatus { paid, partial, outstanding }

/// One invoice, as a line on a statement ledger. There are no separate
/// payment-received rows: what was received against this invoice is carried on
/// the line itself as [paidCents].
class StatementLine {
  const StatementLine({
    required this.invoiceId,
    required this.date,
    required this.invoiceNumber,
    required this.description,
    required this.amountCents,
    required this.paidCents,
    required this.status,
  });

  final int invoiceId;

  /// `invoices.invoiceDate`. A row that fails to parse falls back to the epoch
  /// so a malformed date keeps its amount on the statement instead of dropping
  /// it (same defence as `finalInvoiceStatementProvider`).
  final DateTime date;

  final String invoiceNumber;

  /// The invoice's `workDescription`, falling back to its type label.
  final String description;

  /// Tax-inclusive `invoices.totalAmount`.
  final int amountCents;

  /// Sum of this invoice's non-void payments.
  final int paidCents;

  final LedgerLineStatus status;

  /// Still owing on this line. Never negative (an overpayment reads as zero).
  int get outstandingCents =>
      amountCents - paidCents < 0 ? 0 : amountCents - paidCents;
}

/// A project's overall position, as stated to the client.
enum ProjectStatementStatus {
  /// `isCompleted == 0`. No balance is claimed: the final contract amount can
  /// still move (change orders, unbilled extras), so only paid-to-date is a
  /// real number.
  inProgress,

  /// Completed, but nothing has ever been invoiced — so there is no position to
  /// state. Prevents an empty ledger reading as a false "Paid in Full".
  notInvoiced,

  /// Completed, and every non-deleted invoice fully paid. Deliberately says
  /// nothing about invoice type or contract price — see [_projectStatus].
  paidInFull,

  /// Completed, with at least one invoice not fully paid.
  balanceOwing,
}

/// One project's statement. Built by [buildProjectStatement]; shared verbatim by
/// the client statement (one per row) and the project statement screen, so the
/// two views cannot drift.
class ProjectStatement {
  const ProjectStatement({
    required this.project,
    required this.clientName,
    required this.lines,
    required this.windowBilledCents,
    required this.windowPaidCents,
    required this.lifetimeBilledCents,
    required this.lifetimePaidCents,
    required this.contractAmountCents,
    required this.status,
  });

  final DbProject project;
  final String clientName;

  /// Ledger lines **within the window**, oldest first. Equal to the project's
  /// whole history when no window is set.
  final List<StatementLine> lines;

  /// Σ [lines] — windowed.
  final int windowBilledCents;
  final int windowPaidCents;

  /// Σ over every live invoice on the project, ignoring the window. These are
  /// what [status] and [balanceOwingCents] are derived from.
  final int lifetimeBilledCents;
  final int lifetimePaidCents;

  final ProjectStatementStatus status;

  bool get isFixedPrice => project.pricingModel == 'fixed';
  bool get isCompleted => project.isCompleted != 0;

  /// The contract amount **including tax**, or null for a T&M project (which
  /// has none).
  ///
  /// Tax-inclusive on purpose: every other figure on a statement is
  /// `invoices.totalAmount`, so a bare `projects.projectPrice` — which is the
  /// pre-tax subtotal — would sit beside billed and paid totals it isn't
  /// commensurable with, and read as though the contract had been over-billed.
  /// See [buildProjectStatement] for which tax rate does the grossing up.
  final int? contractAmountCents;

  /// Lifetime billed − lifetime paid. Only meaningful when [hasFinalBalance];
  /// the UI must not present it otherwise.
  int get balanceOwingCents => lifetimeBilledCents - lifetimePaidCents;

  /// True when the project has reached a real, final number.
  ///
  /// Only an unfinished project lacks one — its contract amount can still move
  /// (change orders, unbilled extras), so a balance-owing figure would be a
  /// claim the data can't support. Everything else is final: paid in full, a
  /// definite balance owing, or nothing billed at all (a settled $0).
  bool get hasFinalBalance => status != ProjectStatementStatus.inProgress;
}

/// Every project under one client, plus the grand totals across them.
class ClientStatement {
  const ClientStatement({
    required this.client,
    required this.period,
    required this.window,
    required this.generatedAt,
    required this.projects,
  });

  final DbClient client;
  final StatementPeriod period;

  /// The resolved date window, or null for all-time.
  final DateTimeRange? window;

  final DateTime generatedAt;

  /// Included projects, alphabetical. Flat — every project under the client is
  /// its own row regardless of naming ("101 Kolumbia" and "101 Kolumbia - Deck"
  /// are two independent projects; no parent/child grouping exists or is
  /// inferred).
  final List<ProjectStatement> projects;

  /// Windowed totals — the sum of what the ledgers on this statement show.
  int get windowBilledCents =>
      projects.fold(0, (s, p) => s + p.windowBilledCents);
  int get windowPaidCents => projects.fold(0, (s, p) => s + p.windowPaidCents);

  /// Balance owing across only those projects that have reached a final number.
  /// Summing open projects here would contradict the per-row rule that an
  /// unfinished project claims no balance.
  int get closedBalanceOwingCents => projects
      .where((p) => p.hasFinalBalance)
      .fold(0, (s, p) => s + p.balanceOwingCents);

  /// Projects not yet marked complete — counted so the grand total can say what
  /// it excludes instead of silently under-reporting. Every completed project is
  /// included in the total above, however its contract worked out.
  int get openProjectCount => projects.where((p) => !p.hasFinalBalance).length;
}

// ---------------------------------------------------------------------------
// Date window
// ---------------------------------------------------------------------------

/// Client-statement date filter, applied to `invoices.invoiceDate`.
enum StatementPeriod {
  months3('Last 3 months', 3),
  months6('Last 6 months', 6),
  months12('Last 12 months', 12),
  allTime('All time', null),
  custom('Custom range', null);

  const StatementPeriod(this.label, this.months);

  final String label;

  /// How far back the window reaches, or null when it isn't a rolling window.
  final int? months;
}

/// The preset matching a configured `settings.defaultReportMonths`. Any value
/// other than 6 or 12 falls back to 3 months — the seeded default, and the only
/// other preset offered.
StatementPeriod defaultPeriodForMonths(int? months) => switch (months) {
      6 => StatementPeriod.months6,
      12 => StatementPeriod.months12,
      _ => StatementPeriod.months3,
    };

/// Resolves [period] to a concrete window, or null for all-time.
///
/// Rolling windows end at end-of-today and start at start-of-day N months back,
/// so both ends are inclusive at day precision (matching v1's `_inWindow`).
/// [now] is passed in rather than read here so this stays pure and testable.
DateTimeRange? resolveStatementWindow(
  StatementPeriod period,
  DateTimeRange? customRange, {
  required DateTime now,
}) {
  if (period == StatementPeriod.allTime) return null;
  if (period == StatementPeriod.custom) {
    if (customRange == null) return null;
    return DateTimeRange(
      start: _startOfDay(customRange.start),
      end: _endOfDay(customRange.end),
    );
  }
  final months = period.months!;
  return DateTimeRange(
    start: _startOfDay(DateTime(now.year, now.month - months, now.day)),
    end: _endOfDay(now),
  );
}

DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime _endOfDay(DateTime d) =>
    DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

bool _inWindow(DateTime date, DateTimeRange? window) =>
    window == null ||
    (!date.isBefore(window.start) && !date.isAfter(window.end));

// ---------------------------------------------------------------------------
// Builder (pure — no Drift queries, no ref)
// ---------------------------------------------------------------------------

const _typeLabels = {
  'progress': 'Progress Draw',
  'chargeable': 'Chargeable Extra',
  'addendum': 'Addendum',
  'deposit': 'Deposit',
  'extras': 'Time & Materials',
  'final': 'Final Invoice',
};

/// Builds [project]'s statement from the full invoice list.
///
/// [invoices] is every invoice in the database (the rows for other projects are
/// filtered out here) and [paidByInvoice] the app-wide paid-cents map from
/// `paidCentsByInvoiceProvider` — so payment state is never re-derived locally.
///
/// [window] narrows [ProjectStatement.lines] and the window subtotals only; the
/// lifetime figures and [ProjectStatement.status] always see every live invoice.
///
/// [defaultTaxRatePercent] is the company's default tax-1 rate **as a percent**
/// (`companySettings.defaultTax1Rate × 100` — that column stores a fraction),
/// used only as a fallback when the project has no contract draw to take a rate
/// from. See [_contractTaxRatePercent].
ProjectStatement buildProjectStatement({
  required DbProject project,
  required String clientName,
  required List<DbInvoice> invoices,
  required Map<int, int> paidByInvoice,
  required DateTimeRange? window,
  required double? defaultTaxRatePercent,
}) {
  // Voided invoices are excluded outright — soft-deleted rows are kept for audit
  // and never appear on a client-facing document. Voided PAYMENTS are already
  // excluded upstream by `paidCentsByInvoice`.
  final live = invoices
      .where((i) => i.projectId == project.id && i.isDeleted == 0)
      .toList()
    ..sort((a, b) => a.invoiceDate.compareTo(b.invoiceDate));

  final lines = <StatementLine>[];
  var lifetimeBilled = 0;
  var lifetimePaid = 0;
  var everyInvoicePaid = true;

  for (final i in live) {
    final paid = paidByInvoice[i.id] ?? 0;
    lifetimeBilled += i.totalAmount;
    lifetimePaid += paid;

    final lineStatus = _lineStatus(i, paid);
    if (lineStatus != LedgerLineStatus.paid) everyInvoicePaid = false;

    final date = DateTime.tryParse(i.invoiceDate) ??
        DateTime.fromMillisecondsSinceEpoch(0);
    if (!_inWindow(date, window)) continue;

    final description = (i.workDescription ?? '').trim();
    lines.add(StatementLine(
      invoiceId: i.id,
      date: date,
      invoiceNumber: i.invoiceNumber,
      description: description.isNotEmpty
          ? description
          : (_typeLabels[i.invoiceType] ?? i.invoiceType),
      amountCents: i.totalAmount,
      paidCents: paid,
      status: lineStatus,
    ));
  }

  return ProjectStatement(
    project: project,
    clientName: clientName,
    lines: lines,
    windowBilledCents: lines.fold(0, (s, l) => s + l.amountCents),
    windowPaidCents: lines.fold(0, (s, l) => s + l.paidCents),
    lifetimeBilledCents: lifetimeBilled,
    lifetimePaidCents: lifetimePaid,
    contractAmountCents: _contractAmountCents(
      project,
      live,
      defaultTaxRatePercent,
    ),
    status: _projectStatus(
      project: project,
      hasAnyInvoice: live.isNotEmpty,
      everyInvoicePaid: everyInvoicePaid,
    ),
  );
}

/// The contract price grossed up by tax, or null for a T&M project.
///
/// `projects.projectPrice` is the pre-tax contract subtotal, so it has to be
/// grossed up before it can sit beside the tax-inclusive billed/paid figures.
int? _contractAmountCents(
  DbProject project,
  List<DbInvoice> liveInvoices,
  double? defaultTaxRatePercent,
) {
  if (project.pricingModel != 'fixed') return null;
  final priceExTax = project.projectPrice ?? 0;
  final rate = _contractTaxRatePercent(liveInvoices, defaultTaxRatePercent);
  return priceExTax + taxAmountCents(priceExTax, rate);
}

/// The tax rate (percent) to gross the contract price up by.
///
/// Taken from the project's own **contract draws** — the rate actually charged
/// on this contract — so the grossed-up figure reconciles against the billed
/// total printed beside it. This is the same basis
/// `finalInvoiceStatementProvider` reconciles on, via `finalInvoiceParamsFor`.
///
/// Deliberately NOT `projects.taxRate`: that column is written by the project
/// form and read by nothing that computes money, so on most projects it still
/// holds its 5.0 default whether or not that is what was charged.
///
/// The most recent draw wins when rates differ across draws — no single rate
/// describes a contract billed under two, and the latest is the one the closing
/// figures were struck at. A project with no draws yet falls back to the company
/// default, and to zero if even that is unset (which leaves the price as-is
/// rather than inventing tax).
double _contractTaxRatePercent(
  List<DbInvoice> liveInvoices,
  double? defaultTaxRatePercent,
) {
  // liveInvoices arrives sorted oldest-first, so the last match is the latest.
  DbInvoice? latest;
  for (final i in liveInvoices) {
    if (contractInvoiceTypes.contains(i.invoiceType) &&
        (i.tax1Rate ?? 0) != 0) {
      latest = i;
    }
  }
  return latest?.tax1Rate ?? defaultTaxRatePercent ?? 0;
}

/// Per-line payment state, reusing the app-wide [isInvoiceFullyPaid] rule (and
/// its 1-cent tolerance for v1-era rounding) rather than re-implementing it.
///
/// The zero-total case is handled here because `isInvoiceFullyPaid` requires
/// `totalAmount > 0`; without this a $0 invoice would read OUTSTANDING forever.
LedgerLineStatus _lineStatus(DbInvoice i, int paidCents) {
  if (i.totalAmount <= 0 || isInvoiceFullyPaid(i, paidCents)) {
    return LedgerLineStatus.paid;
  }
  return paidCents > 0 ? LedgerLineStatus.partial : LedgerLineStatus.outstanding;
}

/// Completion + payment, and nothing else.
///
/// "Fully paid" means **every** live invoice is individually fully paid — the
/// per-invoice [isInvoiceFullyPaid] rule applied across the project, rather than
/// an aggregate comparison needing its own invented tolerance.
///
/// Identical for fixed-price and T&M. In particular a fixed-price project needs
/// **no** `'final'`-typed invoice and **no** match between `project_price` and
/// what was actually billed: a deliberate discount or write-off means a contract
/// legitimately closes for less than its price, and that must not hold the
/// project open. A paid project is paid.
ProjectStatementStatus _projectStatus({
  required DbProject project,
  required bool hasAnyInvoice,
  required bool everyInvoicePaid,
}) {
  if (project.isCompleted == 0) return ProjectStatementStatus.inProgress;
  if (!hasAnyInvoice) return ProjectStatementStatus.notInvoiced;
  return everyInvoicePaid
      ? ProjectStatementStatus.paidInFull
      : ProjectStatementStatus.balanceOwing;
}

/// Whether a built statement belongs on the client statement.
///
/// A fixed-price project always appears — its contract amount is information
/// even before anything is drawn. A T&M project appears only once it has a
/// ledger line in the window, which covers both "in progress, nothing invoiced"
/// and "completed, never invoiced": there is nothing to show either way.
bool includeOnClientStatement(ProjectStatement s) =>
    s.isFixedPrice || s.lines.isNotEmpty;

// ---------------------------------------------------------------------------
// Filter state
// ---------------------------------------------------------------------------

/// Client statement selection. [period] is null until the user picks one, so the
/// screen opens on `settings.defaultReportMonths` without the notifier having to
/// wait on an async read.
class StatementFilter {
  const StatementFilter({this.clientId, this.period, this.customRange});

  final int? clientId;
  final StatementPeriod? period;
  final DateTimeRange? customRange;

  StatementFilter copyWith({
    int? Function()? clientId,
    StatementPeriod? period,
    DateTimeRange? Function()? customRange,
  }) =>
      StatementFilter(
        clientId: clientId != null ? clientId() : this.clientId,
        period: period ?? this.period,
        customRange: customRange != null ? customRange() : this.customRange,
      );
}

class StatementFilterNotifier extends Notifier<StatementFilter> {
  @override
  StatementFilter build() => const StatementFilter();

  void setClient(int? id) => state = state.copyWith(clientId: () => id);

  /// Selecting a non-custom period drops any custom range, so a stale range
  /// can't survive behind a preset and reappear later.
  void setPeriod(StatementPeriod period) => state = state.copyWith(
        period: period,
        customRange:
            period == StatementPeriod.custom ? () => state.customRange : () => null,
      );

  void setCustomRange(DateTimeRange range) => state = state.copyWith(
        period: StatementPeriod.custom,
        customRange: () => range,
      );
}

final statementFilterProvider =
    NotifierProvider<StatementFilterNotifier, StatementFilter>(
  StatementFilterNotifier.new,
);

/// Free-text filter for the project statement screen's picker.
class ProjectSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void set(String value) => state = value;
  void clear() => state = '';
}

final projectSearchProvider =
    NotifierProvider<ProjectSearchNotifier, String>(ProjectSearchNotifier.new);

// ---------------------------------------------------------------------------
// Derived providers
// ---------------------------------------------------------------------------

/// (Local copy — the other provider files each keep their own private one.)
T? _firstOrNull<T>(Iterable<T> it) => it.isEmpty ? null : it.first;

/// The seeded "Company Expenses" client — identified by owning the `isInternal`
/// project, the same way `cost_record_form` finds it. Excluded from every
/// statement picker: it is the overhead bucket, not a real client.
int? _internalClientId(List<DbProject> projects) {
  for (final p in projects) {
    if (p.isInternal != 0) return p.clientId;
  }
  return null;
}

/// Clients selectable on the client statement: active, excluding the internal
/// overhead client. Alphabetical (inherited from `ClientsDao`).
final statementClientsProvider = Provider<AsyncValue<List<DbClient>>>((ref) {
  final clientsA = ref.watch(clientsStreamProvider);
  final projectsA = ref.watch(projectsStreamProvider);

  return combineAsync([clientsA, projectsA], () {
    final internalId = _internalClientId(projectsA.requireValue);
    return clientsA.requireValue
        .where((c) => c.isActive != 0 && c.id != internalId)
        .toList();
  });
});

/// The effective period: the user's explicit choice, else the configured
/// `settings.defaultReportMonths` (seeded to 3).
final effectiveStatementPeriodProvider =
    Provider<AsyncValue<StatementPeriod>>((ref) {
  final filter = ref.watch(statementFilterProvider);
  final settingsA = ref.watch(appSettingsStreamProvider);

  return combineAsync([settingsA], () =>
      filter.period ??
      defaultPeriodForMonths(settingsA.requireValue?.defaultReportMonths));
});

/// The selected client's statement, or null when no client is chosen.
final clientStatementProvider = Provider<AsyncValue<ClientStatement?>>((ref) {
  final filter = ref.watch(statementFilterProvider);
  final periodA = ref.watch(effectiveStatementPeriodProvider);
  final invoicesA = ref.watch(invoicesStreamProvider);
  final paidA = ref.watch(paidCentsByInvoiceProvider);
  final projectsA = ref.watch(projectsStreamProvider);
  final clientsA = ref.watch(clientsStreamProvider);
  final companyA = ref.watch(companySettingsStreamProvider);

  return combineAsync(
      [periodA, invoicesA, paidA, projectsA, clientsA, companyA], () {
    final clientId = filter.clientId;
    if (clientId == null) return null;

    final client =
        _firstOrNull(clientsA.requireValue.where((c) => c.id == clientId));
    if (client == null) return null;

    final period = periodA.requireValue;
    final now = DateTime.now();
    final window = resolveStatementWindow(period, filter.customRange, now: now);

    // Every project under the client, flat — no parent/child grouping is
    // inferred from names. Internal/overhead projects excluded.
    final projects = projectsA.requireValue
        .where((p) => p.clientId == clientId && p.isInternal == 0)
        .map((p) => buildProjectStatement(
              project: p,
              clientName: client.name,
              invoices: invoicesA.requireValue,
              paidByInvoice: paidA.requireValue,
              window: window,
              defaultTaxRatePercent:
                  _defaultTaxRatePercent(companyA.requireValue),
            ))
        .where(includeOnClientStatement)
        .toList();

    return ClientStatement(
      client: client,
      period: period,
      window: window,
      generatedAt: now,
      projects: projects,
    );
  });
});

/// One project's complete statement — no date window, since it is already scoped
/// to a single project's full history. Null if the project no longer exists.
final projectStatementProvider =
    Provider.family<AsyncValue<ProjectStatement?>, int>((ref, projectId) {
  final invoicesA = ref.watch(invoicesStreamProvider);
  final paidA = ref.watch(paidCentsByInvoiceProvider);
  final projectsA = ref.watch(projectsStreamProvider);
  final clientsA = ref.watch(clientsStreamProvider);
  final companyA = ref.watch(companySettingsStreamProvider);

  return combineAsync([invoicesA, paidA, projectsA, clientsA, companyA], () {
    final project =
        _firstOrNull(projectsA.requireValue.where((p) => p.id == projectId));
    if (project == null) return null;

    final client = _firstOrNull(
        clientsA.requireValue.where((c) => c.id == project.clientId));

    return buildProjectStatement(
      project: project,
      clientName: client?.name ?? '—',
      invoices: invoicesA.requireValue,
      paidByInvoice: paidA.requireValue,
      window: null,
      defaultTaxRatePercent: _defaultTaxRatePercent(companyA.requireValue),
    );
  });
});

/// The company's default tax-1 rate as a **percent**.
///
/// `companySettings.defaultTax1Rate` stores a FRACTION (0.05 = 5%), unlike
/// `invoices.tax1Rate`, which stores a percent (5.0). The settings tab does the
/// same ×100 on read. Getting this wrong would gross a contract up by 0.05%
/// instead of 5% — silently, and only on projects with no draws to take a rate
/// from.
double? _defaultTaxRatePercent(DbCompanySetting? company) =>
    company == null ? null : company.defaultTax1Rate * 100;

/// One client's projects, for the project-statement picker.
class ProjectPickerGroup {
  const ProjectPickerGroup({required this.clientName, required this.projects});

  final String clientName;
  final List<DbProject> projects;
}

/// Projects grouped by client for the picker, filtered by
/// [projectSearchProvider]. The query matches on project OR client name, so
/// "kelly" finds every Kelly Fry job and "kolumbia" finds them by address.
/// Internal/overhead projects are excluded.
final projectPickerProvider =
    Provider<AsyncValue<List<ProjectPickerGroup>>>((ref) {
  final projectsA = ref.watch(projectsStreamProvider);
  final clientsA = ref.watch(clientsStreamProvider);
  final query = ref.watch(projectSearchProvider).trim().toLowerCase();

  return combineAsync([projectsA, clientsA], () {
    final clientNames = {
      for (final c in clientsA.requireValue) c.id: c.name,
    };
    final internalId = _internalClientId(projectsA.requireValue);

    final matches = projectsA.requireValue.where((p) {
      if (p.isInternal != 0 || p.clientId == internalId) return false;
      if (query.isEmpty) return true;
      final client = (clientNames[p.clientId] ?? '').toLowerCase();
      return p.projectName.toLowerCase().contains(query) ||
          client.contains(query);
    });

    final byClient = <int, List<DbProject>>{};
    for (final p in matches) {
      byClient.putIfAbsent(p.clientId, () => []).add(p);
    }

    // Clients alphabetically; projects keep the DAO's case-insensitive order.
    final ids = byClient.keys.toList()
      ..sort((a, b) => (clientNames[a] ?? '')
          .toLowerCase()
          .compareTo((clientNames[b] ?? '').toLowerCase()));

    return [
      for (final id in ids)
        ProjectPickerGroup(
          clientName: clientNames[id] ?? '—',
          projects: byClient[id]!,
        ),
    ];
  });
});
