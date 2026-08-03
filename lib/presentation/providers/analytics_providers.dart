import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/billing_calc.dart';
import '../../data/local/drift/app_database.dart';
import 'client_project_providers.dart';
import 'cost_entry_providers.dart';
import 'database_provider.dart';
import 'invoice_providers.dart';
import 'reference_data_providers.dart';
import 'time_entry_providers.dart';

/// Analytics module — provider layer only (no screens/UI).
///
/// Three concerns live here:
///   1. Import / reconciliation of externally-parsed time entries.
///   2. Standard reports (project summary/list, personnel, company expenses).
///   3. Financial / P&L summary.
///
/// All money is in integer **cents** (the stored unit); the provider layer never
/// divides for display — that's the UI's job. Reports derive from the existing
/// reactive streams via [_combine] so they refresh automatically, and value
/// labour/materials through `billing_calc` so there's exactly one rate/markup
/// code path shared with the records and invoice features.

// ===========================================================================
// 1. Import / reconciliation
// ===========================================================================

/// One row of an external time-entry import. The caller has already parsed the
/// source file (CSV/spreadsheet/etc.) — file IO and parsing are not the provider
/// layer's job. Every field is raw text; resolution against reference data and
/// validation happen in [AnalyticsImportActions.importTimeEntries].
class ImportTimeEntryRow {
  const ImportTimeEntryRow({
    required this.rowNumber,
    this.projectName,
    this.employeeName,
    this.startTime,
    this.endTime,
    this.costCodeName,
    this.workDetails,
  });

  /// 1-based source row number, used purely for error reporting.
  final int rowNumber;
  final String? projectName;
  final String? employeeName;
  final String? startTime;
  final String? endTime;
  final String? costCodeName;
  final String? workDetails;
}

/// A single source row that could not be imported, with the reason why. Rows
/// that fail validation are collected rather than aborting the whole batch
/// (best-effort import + reconciliation report).
class ImportError {
  const ImportError({
    required this.rowNumber,
    required this.reason,
    this.detail,
  });

  final int rowNumber;
  final String reason;
  final String? detail;

  @override
  String toString() =>
      'Row $rowNumber: $reason${detail == null ? '' : ' ($detail)'}';
}

/// Outcome of one import run: how many rows landed plus the per-row problems.
class ImportSummary {
  const ImportSummary({required this.imported, required this.errors});

  final int imported;
  final List<ImportError> errors;

  /// Convenience alias matching the module's vocabulary.
  List<ImportError> get importErrors => errors;
  bool get hasErrors => errors.isNotEmpty;
  int get totalRows => imported + errors.length;
}

/// Drives time-entry imports and surfaces the reconciliation result:
///
/// - `AsyncData(null)`      — idle, no import run yet
/// - `AsyncLoading`         — import in progress
/// - `AsyncData(summary)`   — finished; `summary.importErrors` lists any
///                            rows that couldn't be reconciled
/// - `AsyncError`           — the run failed outright (e.g. reference data
///                            couldn't be read)
class AnalyticsImportActions extends AsyncNotifier<ImportSummary?> {
  @override
  FutureOr<ImportSummary?> build() => null;

  /// Validates [rows] against current reference data and inserts the ones that
  /// reconcile. Invalid rows (missing/unknown project, unparseable times,
  /// unknown employee/cost code) are skipped and collected into
  /// [ImportSummary.importErrors]; valid rows are still imported.
  Future<void> importTimeEntries(List<ImportTimeEntryRow> rows) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<ImportSummary?>(() async {
      final db = ref.read(databaseProvider);
      final repo = ref.read(timeEntryRepositoryProvider);

      // Read reference data once and resolve by (trimmed, lower-cased) name.
      final projectByName = _indexByName(
          await ref.read(projectsStreamProvider.future),
          (DbProject p) => p.projectName, (p) => p.id);
      final employeeByName = _indexByName(
          await ref.read(employeesStreamProvider.future),
          (DbEmployee e) => e.name, (e) => e.id);
      final costCodeByName = _indexByName(
          await ref.read(costCodesStreamProvider.future),
          (DbCostCode c) => c.name, (c) => c.id);
      final interval =
          (await db.settingsDao.getSettings())?.timeRoundingInterval;

      final errors = <ImportError>[];
      var imported = 0;

      for (final row in rows) {
        final projectName = row.projectName?.trim() ?? '';
        if (projectName.isEmpty) {
          errors.add(ImportError(rowNumber: row.rowNumber, reason: 'Missing project'));
          continue;
        }
        final projectId = projectByName[projectName.toLowerCase()];
        if (projectId == null) {
          errors.add(ImportError(
              rowNumber: row.rowNumber,
              reason: 'Unknown project',
              detail: projectName));
          continue;
        }

        final start = DateTime.tryParse(row.startTime?.trim() ?? '');
        if (start == null) {
          errors.add(ImportError(
              rowNumber: row.rowNumber,
              reason: 'Missing or invalid start time',
              detail: row.startTime));
          continue;
        }

        DateTime? end;
        final endRaw = row.endTime?.trim() ?? '';
        if (endRaw.isNotEmpty) {
          end = DateTime.tryParse(endRaw);
          if (end == null) {
            errors.add(ImportError(
                rowNumber: row.rowNumber,
                reason: 'Invalid end time',
                detail: row.endTime));
            continue;
          }
        }

        int? employeeId;
        final empName = row.employeeName?.trim() ?? '';
        if (empName.isNotEmpty) {
          employeeId = employeeByName[empName.toLowerCase()];
          if (employeeId == null) {
            errors.add(ImportError(
                rowNumber: row.rowNumber,
                reason: 'Unknown employee',
                detail: empName));
            continue;
          }
        }

        int? costCodeId;
        final ccName = row.costCodeName?.trim() ?? '';
        if (ccName.isNotEmpty) {
          costCodeId = costCodeByName[ccName.toLowerCase()];
          if (costCodeId == null) {
            errors.add(ImportError(
                rowNumber: row.rowNumber,
                reason: 'Unknown cost code',
                detail: ccName));
            continue;
          }
        }

        // Billed duration mirrors the manual-entry path: raw span rounded to
        // the settings interval (null when there's no end time yet).
        final billed = end == null
            ? null
            : _applyTimeRounding(
                end.difference(start).inSeconds.toDouble(), interval);
        final details = row.workDetails?.trim();

        try {
          await repo.insertRow(TimeEntriesCompanion.insert(
            projectId: projectId,
            startTime: start.toIso8601String(),
            employeeId: Value(employeeId),
            endTime: Value(end?.toIso8601String()),
            finalBilledDurationSeconds: Value(billed),
            costCodeId: Value(costCodeId),
            workDetails:
                Value((details == null || details.isEmpty) ? null : details),
          ));
          imported++;
        } catch (e) {
          errors.add(ImportError(
              rowNumber: row.rowNumber, reason: 'Insert failed', detail: '$e'));
        }
      }

      if (imported > 0) ref.invalidate(timeEntriesStreamProvider);
      return ImportSummary(imported: imported, errors: errors);
    });
  }

  /// Rounds [seconds] to the nearest [intervalMinutes] boundary. Null/zero =
  /// no rounding. Mirrors the original app's `_applyTimeRounding`.
  static double _applyTimeRounding(double seconds, int? intervalMinutes) {
    if (intervalMinutes == null || intervalMinutes == 0) return seconds;
    final intervalSeconds = intervalMinutes * 60;
    return (seconds / intervalSeconds).round() * intervalSeconds.toDouble();
  }
}

final analyticsImportActionsProvider =
    AsyncNotifierProvider.autoDispose<AnalyticsImportActions, ImportSummary?>(
  AnalyticsImportActions.new,
);

// ===========================================================================
// 2. Standard reports
// ===========================================================================

/// Per-project rollup of logged activity, bucketed by cost-code
/// [CostCodeCategory] and valued via `billing_calc`. All money in cents.
///
/// Internal-coded entries are dropped entirely (overhead); entries/materials
/// with a null/unrecognised cost code are excluded from every total and counted
/// in [needsReviewCount] instead. `parentProjectId` is carried through only.
class ProjectSummary {
  const ProjectSummary({
    required this.project,
    required this.clientName,
    required this.totalHours,
    required this.contractCostCents,
    required this.tmCostCents,
    required this.tmBillableCents,
    required this.noChargeCents,
    required this.needsReviewCount,
    required this.hasCustomLabourRate,
  });

  final DbProject project;
  final String clientName;

  /// Total logged hours for the project — ALL completed, non-deleted entries,
  /// independent of cost-code classification. A project's hours are a factual
  /// quantity, so (unlike the money figures) they must not depend on whether
  /// cost codes have been classified yet. Includes Internal and needs-review
  /// hours; only the money buckets branch by category.
  final double totalHours;

  /// Cost of Contract Work: employee-rate labour (summed per entry, so mixed
  /// crews rate correctly) + raw Contract Work materials. The fixed-price cost
  /// basis (Decision B).
  final int contractCostCents;

  /// T&M cost (Decision C): burden-rate labour over Billable hours + raw
  /// Billable materials. Billable-coded work only. On a fixed-price project this
  /// is the cost of above-contract "extras".
  final int tmCostCents;

  /// Logged billable value (revenue side) of Billable-coded work: labour at the
  /// billing rate + marked-up Billable materials.
  final int tmBillableCents;

  /// The "No Charge" figure: billable value deliberately not charged — No Charge
  /// labour at the billing rate + marked-up No Charge materials. Tracked on its
  /// own and excluded from cost (unbilled by choice, not a loss).
  final int noChargeCents;

  /// Count of unbilled-scope time entries + materials whose cost code is
  /// null/unrecognised — excluded from all totals, surfaced for review.
  final int needsReviewCount;

  /// True when the project defines its own hourly rate (`billedHourlyRate`,
  /// non-null/non-zero) that differs from the company **Default Billing Rate**
  /// it would otherwise bill at. Labour COST still uses the burden rate
  /// regardless (locked rule) — this flag exists only to let the UI flag the
  /// row so the ignored custom rate is visible.
  final bool hasCustomLabourRate;

  /// Passthrough only — no parent/child rollup at this stage.
  int? get parentProjectId => project.parentProjectId;
}

/// One [ProjectSummary] per project (every project, including zero-activity
/// ones), sorted by project name.
final projectListReportProvider =
    Provider<AsyncValue<List<ProjectSummary>>>((ref) {
  final projectsA = ref.watch(projectsStreamProvider);
  final clientsA = ref.watch(clientsStreamProvider);
  final entriesA = ref.watch(timeEntriesStreamProvider);
  final materialsA = ref.watch(materialsStreamProvider);
  final employeesA = ref.watch(employeesStreamProvider);
  final rolesA = ref.watch(rolesStreamProvider);
  final costCodesA = ref.watch(costCodesStreamProvider);
  final settingsA = ref.watch(appSettingsStreamProvider);

  return _combine([
    projectsA,
    clientsA,
    entriesA,
    materialsA,
    employeesA,
    rolesA,
    costCodesA,
    settingsA,
  ], () {
    return _buildProjectSummaries(
      projects: projectsA.requireValue,
      clients: clientsA.requireValue,
      entries: entriesA.requireValue,
      materials: materialsA.requireValue,
      employees: employeesA.requireValue,
      roles: rolesA.requireValue,
      costCodes: costCodesA.requireValue,
      burdenRateDollars: settingsA.requireValue?.burdenRate,
      companyDefaultRateCents: settingsA.requireValue?.companyHourlyRate,
    );
  });
});

/// Summary for a single project. Null if the project doesn't exist.
final projectSummaryProvider =
    Provider.family<AsyncValue<ProjectSummary?>, int>((ref, projectId) {
  return ref.watch(projectListReportProvider).whenData(
        (list) => _firstOrNull(list.where((s) => s.project.id == projectId)),
      );
});

/// Per-employee hours + billable labour rollup. Entries with no employee are
/// aggregated under a single "Unassigned" row (`employeeId == null`).
class PersonnelReportRow {
  const PersonnelReportRow({
    required this.employeeId,
    required this.employeeName,
    required this.totalHours,
    required this.labourCents,
    required this.entryCount,
  });

  final int? employeeId;
  final String employeeName;
  final double totalHours;
  final int labourCents;
  final int entryCount;
}

final personnelReportProvider =
    Provider<AsyncValue<List<PersonnelReportRow>>>((ref) {
  final entriesA = ref.watch(timeEntriesStreamProvider);
  final projectsA = ref.watch(projectsStreamProvider);
  final employeesA = ref.watch(employeesStreamProvider);
  final rolesA = ref.watch(rolesStreamProvider);
  final settingsA = ref.watch(appSettingsStreamProvider);

  return _combine([entriesA, projectsA, employeesA, rolesA, settingsA], () {
    final projectById = {for (final p in projectsA.requireValue) p.id: p};
    final employeeById = {for (final e in employeesA.requireValue) e.id: e};
    final roleById = {for (final r in rolesA.requireValue) r.id: r};
    final companyDefaultRateCents = settingsA.requireValue?.companyHourlyRate;

    final hours = <int?, double>{};
    final labour = <int?, int>{};
    final count = <int?, int>{};

    for (final e in entriesA.requireValue) {
      final project = projectById[e.projectId];
      if (project == null) continue;
      final billedSeconds = (e.finalBilledDurationSeconds ?? 0).toDouble();
      final rateCents = hourlyRateCents(
        project,
        e.employeeId,
        employeeById,
        roleById,
        companyDefaultRateCents: companyDefaultRateCents,
      );
      final key = e.employeeId;
      hours[key] = (hours[key] ?? 0) + billedSeconds / 3600;
      labour[key] = (labour[key] ?? 0) + labourValueCents(rateCents, billedSeconds);
      count[key] = (count[key] ?? 0) + 1;
    }

    final rows = [
      for (final key in count.keys)
        PersonnelReportRow(
          employeeId: key,
          employeeName: key == null
              ? 'Unassigned'
              : (employeeById[key]?.name ?? 'Unknown'),
          totalHours: hours[key] ?? 0,
          labourCents: labour[key] ?? 0,
          entryCount: count[key] ?? 0,
        ),
    ]..sort((a, b) => a.employeeName.compareTo(b.employeeName));
    return rows;
  });
});

/// A company-expense material (billed without markup), resolved with its
/// project name.
class CompanyExpenseRow {
  const CompanyExpenseRow({required this.material, required this.projectName});

  final DbMaterial material;
  final String projectName;

  /// Raw cost in cents — company expenses carry no markup.
  int get costCents => material.cost;
}

/// All non-deleted company-expense materials plus their total.
class CompanyExpensesReport {
  const CompanyExpensesReport({required this.rows, required this.totalCents});

  final List<CompanyExpenseRow> rows;
  final int totalCents;
}

final companyExpensesReportProvider =
    Provider<AsyncValue<CompanyExpensesReport>>((ref) {
  final materialsA = ref.watch(materialsStreamProvider);
  final projectsA = ref.watch(projectsStreamProvider);

  return _combine([materialsA, projectsA], () {
    final projectName = {
      for (final p in projectsA.requireValue) p.id: p.projectName
    };
    final rows = <CompanyExpenseRow>[];
    var total = 0;
    for (final m in materialsA.requireValue) {
      if (m.isDeleted != 0 || m.isCompanyExpense == 0) continue;
      rows.add(CompanyExpenseRow(
        material: m,
        projectName: projectName[m.projectId] ?? '—',
      ));
      total += m.cost; // no markup on company expenses
    }
    rows.sort((a, b) => b.costCents.compareTo(a.costCents));
    return CompanyExpensesReport(rows: rows, totalCents: total);
  });
});

// ===========================================================================
// 3. Financial / P&L summary
// ===========================================================================

enum ProjectFinancialKind { timeAndMaterials, fixedPrice }

/// One project's financial snapshot for the landing page. All money in cents.
///
/// Carries both fixed-price and T&M fields; which are meaningful depends on
/// [kind] (the card renders each type in its own table). Cost/value figures come
/// from [ProjectSummary] (cost-code-bucketed); invoice figures are resolved here
/// from the invoice stream.
///
/// Margins are branched, not uniform:
///   - Fixed-price: [contractMarginCents] = contract price − Contract Work cost
///     (Decision B); [extrasMarginCents] = invoiced extras − Billable cost
///     (Decision D), kept separate from the contract margin.
///   - T&M: [tmMarginCents] = invoiced-to-date − T&M cost.
class FinancialSummaryRow {
  const FinancialSummaryRow({
    required this.project,
    required this.clientName,
    required this.kind,
    required this.totalHours,
    required this.contractValueCents,
    required this.contractCostCents,
    required this.invoicedToDateCents,
    required this.extrasInvoicedCents,
    required this.tmCostCents,
    required this.loggedBillableCents,
    required this.noChargeCents,
    required this.needsReviewCount,
    required this.hasCustomLabourRate,
  });

  final DbProject project;
  final String clientName;
  final ProjectFinancialKind kind;
  final double totalHours;

  /// Fixed-price contract price (this project's own; no rollup). 0 for T&M.
  final int contractValueCents;

  /// Cost of Contract Work — the fixed-price cost basis. 0 for T&M.
  final int contractCostCents;

  /// All non-deleted invoice subtotals for the project (contract draws + extras).
  final int invoicedToDateCents;

  /// Invoiced 'extras' subtotals only — above-contract Billable work. Meaningful
  /// for fixed-price rows.
  final int extrasInvoicedCents;

  /// Cost of Billable-coded work (burden labour + raw materials). On a T&M row
  /// this is the project's cost; on a fixed-price row it's the extras cost.
  final int tmCostCents;

  /// Logged billable value of Billable-coded work (revenue side).
  final int loggedBillableCents;

  /// "No Charge" figure — billable value deliberately not charged.
  final int noChargeCents;

  /// Entries/materials needing a cost code (excluded from all totals).
  final int needsReviewCount;

  final bool hasCustomLabourRate;

  bool get isFixed => kind == ProjectFinancialKind.fixedPrice;

  /// Passthrough only — no parent/child rollup at this stage.
  int? get parentProjectId => project.parentProjectId;

  /// Fixed-price contract margin = contract price − Contract Work cost.
  int get contractMarginCents => contractValueCents - contractCostCents;

  /// Fixed-price extras margin = invoiced extras − Billable-coded cost.
  int get extrasMarginCents => extrasInvoicedCents - tmCostCents;

  /// T&M margin = invoiced-to-date − T&M cost.
  int get tmMarginCents => invoicedToDateCents - tmCostCents;

  /// Total cost attributed to the project (Contract Work + Billable-coded work).
  int get totalCostCents => contractCostCents + tmCostCents;
}

/// Per-project financial rows plus aggregate totals (informational; the card
/// renders per-project, never blended).
class FinancialSummary {
  const FinancialSummary({
    required this.rows,
    required this.loggedBillableCents,
    required this.invoicedToDateCents,
    required this.totalCostCents,
    required this.noChargeCents,
    required this.needsReviewCount,
    required this.fixedContractValueCents,
  });

  final List<FinancialSummaryRow> rows;
  final int loggedBillableCents;
  final int invoicedToDateCents;
  final int totalCostCents;
  final int noChargeCents;
  final int needsReviewCount;

  /// Sum of fixed-price contract values (own prices only) — informational.
  final int fixedContractValueCents;
}

final financialSummaryProvider = Provider<AsyncValue<FinancialSummary>>((ref) {
  final summariesA = ref.watch(projectListReportProvider);
  final invoicesA = ref.watch(invoicesStreamProvider);

  return _combine([summariesA, invoicesA], () {
    final invoices = invoicesA.requireValue;
    final rows = <FinancialSummaryRow>[];
    var loggedTotal = 0;
    var invoicedTotal = 0;
    var costTotal = 0;
    var noChargeTotal = 0;
    var needsReviewTotal = 0;
    var fixedContract = 0;

    for (final s in summariesA.requireValue) {
      final p = s.project;
      final isFixed = p.pricingModel == 'fixed';
      final contractValue = isFixed ? (p.projectPrice ?? 0) : 0;
      final row = FinancialSummaryRow(
        project: p,
        clientName: s.clientName,
        kind: isFixed
            ? ProjectFinancialKind.fixedPrice
            : ProjectFinancialKind.timeAndMaterials,
        totalHours: s.totalHours,
        contractValueCents: contractValue,
        contractCostCents: s.contractCostCents,
        // Invoiced-to-date is every non-deleted invoice for the project;
        // extras-only is split out so fixed-price rows can show above-contract
        // work distinct from the contract margin.
        invoicedToDateCents: invoicedToDate(invoices, p.id),
        extrasInvoicedCents: extrasInvoicedToDate(invoices, p.id),
        tmCostCents: s.tmCostCents,
        loggedBillableCents: s.tmBillableCents,
        noChargeCents: s.noChargeCents,
        needsReviewCount: s.needsReviewCount,
        hasCustomLabourRate: s.hasCustomLabourRate,
      );
      rows.add(row);
      loggedTotal += row.loggedBillableCents;
      invoicedTotal += row.invoicedToDateCents;
      costTotal += row.totalCostCents;
      noChargeTotal += row.noChargeCents;
      needsReviewTotal += row.needsReviewCount;
      if (isFixed) fixedContract += contractValue;
    }

    return FinancialSummary(
      rows: rows,
      loggedBillableCents: loggedTotal,
      invoicedToDateCents: invoicedTotal,
      totalCostCents: costTotal,
      noChargeCents: noChargeTotal,
      needsReviewCount: needsReviewTotal,
      fixedContractValueCents: fixedContract,
    );
  });
});

// ===========================================================================
// UI selection state (analytics landing page)
// ===========================================================================

/// Selection state for the Analytics landing page — a UI filter notifier (same
/// family as `invoiceListFilterProvider` / `timeEntryFilterProvider`), NOT a
/// calculation provider. It is the single source of truth for which project's
/// financials the hub shows; there is deliberately no second project selector.

enum AnalyticsReportType { activeProjects, completedProjects }

class AnalyticsSelection {
  const AnalyticsSelection({
    this.reportType = AnalyticsReportType.activeProjects,
    this.selectedProjectId,
  });

  final AnalyticsReportType reportType;

  /// `null` == "All Projects".
  final int? selectedProjectId;
}

class AnalyticsSelectionNotifier extends Notifier<AnalyticsSelection> {
  @override
  AnalyticsSelection build() => const AnalyticsSelection();

  /// Switching report type clears the project selection (the project list is
  /// scoped to active vs completed), mirroring v1's `_loadProjects` reset.
  void setReportType(AnalyticsReportType type) =>
      state = AnalyticsSelection(reportType: type);

  void setProject(int? projectId) => state = AnalyticsSelection(
        reportType: state.reportType,
        selectedProjectId: projectId,
      );
}

final analyticsSelectionProvider =
    NotifierProvider<AnalyticsSelectionNotifier, AnalyticsSelection>(
  AnalyticsSelectionNotifier.new,
);

// ===========================================================================
// helpers (kept local; mirrors the duplication already in the other provider
// files — no shared-file refactor in this change)
// ===========================================================================

T? _firstOrNull<T>(Iterable<T> it) => it.isEmpty ? null : it.first;

/// Builds a `lower-cased name → id` lookup, first occurrence winning. Blank
/// names are skipped.
Map<String, int> _indexByName<T>(
    Iterable<T> items, String Function(T) name, int Function(T) id) {
  final m = <String, int>{};
  for (final it in items) {
    final key = name(it).trim().toLowerCase();
    if (key.isEmpty) continue;
    m.putIfAbsent(key, () => id(it));
  }
  return m;
}

List<ProjectSummary> _buildProjectSummaries({
  required List<DbProject> projects,
  required List<DbClient> clients,
  required List<DbTimeEntry> entries,
  required List<DbMaterial> materials,
  required List<DbEmployee> employees,
  required List<DbRole> roles,
  required List<DbCostCode> costCodes,
  required double? burdenRateDollars,
  required int? companyDefaultRateCents,
}) {
  final projectById = {for (final p in projects) p.id: p};
  final clientById = {for (final c in clients) c.id: c};
  final employeeById = {for (final e in employees) e.id: e};
  final roleById = {for (final r in roles) r.id: r};
  final costCodeById = {for (final c in costCodes) c.id: c};

  // "Custom rate" means the project bills at something other than what it
  // WOULD bill at by default — i.e. the company Default Billing Rate
  // (`settings.companyHourlyRate`, already in cents). Deliberately NOT the
  // burden rate: that is the internal cost figure and never bills a client, so
  // comparing against it flagged the wrong rows. Labour cost still ignores the
  // project rate entirely (locked rule); this only drives a UI highlight.
  bool customRate(DbProject p) {
    final r = p.billedHourlyRate;
    return r != null && r != 0 && r != companyDefaultRateCents;
  }

  // Per-project accumulators. Hours are classification-INDEPENDENT (every logged
  // entry counts toward the displayed total). The MONEY buckets branch by the
  // entry/material's CostCodeCategory: Internal is dropped (overhead); a
  // null/unrecognised code lands in needsReview instead of any money total.
  final allHours = <int, double>{}; // ALL logged hours (classification-independent)
  final billableHours = <int, double>{}; // Billable hours only — drives T&M cost
  final contractLabourCost = <int, int>{}; // Contract Work labour @ employee rate
  final contractMatCost = <int, int>{}; // Contract Work materials (raw)
  final billableMatRaw = <int, int>{}; // Billable materials (raw) — T&M cost side
  final tmBillableLabour = <int, int>{}; // Billable labour @ billing rate
  final tmBillableMat = <int, int>{}; // Billable materials, marked up
  final noChargeLabour = <int, int>{}; // No Charge labour @ billing rate
  final noChargeMat = <int, int>{}; // No Charge materials, marked up
  final needsReview = <int, int>{}; // entries + materials with no valid code

  for (final e in entries) {
    final project = projectById[e.projectId];
    if (project == null) continue;
    final pid = e.projectId;
    final billedSeconds = (e.finalBilledDurationSeconds ?? 0).toDouble();
    final hours = billedSeconds / 3600;
    // Hours are classification-independent: every logged entry counts.
    allHours[pid] = (allHours[pid] ?? 0) + hours;
    switch (classifyCostCode(e.costCodeId, costCodeById)) {
      case CostCodeCategory.contract:
        {
          // Employee pay rate (per entry, so mixed crews rate correctly).
          final empRate =
              employeeRateCents(e.employeeId, employeeById, roleById);
          contractLabourCost[pid] = (contractLabourCost[pid] ?? 0) +
              labourValueCents(empRate, billedSeconds);
        }
        break;
      case CostCodeCategory.billable:
        {
          billableHours[pid] = (billableHours[pid] ?? 0) + hours;
          final rate = hourlyRateCents(
            project,
            e.employeeId,
            employeeById,
            roleById,
            companyDefaultRateCents: companyDefaultRateCents,
          );
          tmBillableLabour[pid] = (tmBillableLabour[pid] ?? 0) +
              labourValueCents(rate, billedSeconds);
        }
        break;
      case CostCodeCategory.noCharge:
        {
          final rate = hourlyRateCents(
            project,
            e.employeeId,
            employeeById,
            roleById,
            companyDefaultRateCents: companyDefaultRateCents,
          );
          noChargeLabour[pid] =
              (noChargeLabour[pid] ?? 0) + labourValueCents(rate, billedSeconds);
        }
        break;
      case CostCodeCategory.internal:
        break; // overhead — excluded from client-facing money totals
      case CostCodeCategory.needsReview:
        needsReview[pid] = (needsReview[pid] ?? 0) + 1;
        break;
    }
  }

  for (final m in materials) {
    // Company expenses are overhead, not a project material — still excluded.
    if (m.isDeleted != 0 || m.isCompanyExpense != 0) continue;
    final project = projectById[m.projectId];
    if (project == null) continue;
    final pid = m.projectId;
    final markup = effectiveMarkupPercent(project);
    switch (classifyCostCode(m.costCodeId, costCodeById)) {
      case CostCodeCategory.contract:
        contractMatCost[pid] = (contractMatCost[pid] ?? 0) + m.cost;
        break;
      case CostCodeCategory.billable:
        billableMatRaw[pid] = (billableMatRaw[pid] ?? 0) + m.cost;
        tmBillableMat[pid] =
            (tmBillableMat[pid] ?? 0) + markedUpCostCents(m.cost, markup);
        break;
      case CostCodeCategory.noCharge:
        noChargeMat[pid] =
            (noChargeMat[pid] ?? 0) + markedUpCostCents(m.cost, markup);
        break;
      case CostCodeCategory.internal:
        break;
      case CostCodeCategory.needsReview:
        needsReview[pid] = (needsReview[pid] ?? 0) + 1;
        break;
    }
  }

  final summaries = [
    for (final p in projects)
      ProjectSummary(
        project: p,
        clientName: clientById[p.clientId]?.name ?? '—',
        totalHours: allHours[p.id] ?? 0,
        // Fixed-price cost basis: Contract Work labour (employee rate) + raw
        // Contract Work materials.
        contractCostCents:
            (contractLabourCost[p.id] ?? 0) + (contractMatCost[p.id] ?? 0),
        // T&M cost (Decision C): burden-rate labour over Billable hours + raw
        // Billable materials. Billable-coded work only, burden rate regardless
        // of pricing model.
        tmCostCents:
            labourCostCents(billableHours[p.id] ?? 0, burdenRateDollars) +
                (billableMatRaw[p.id] ?? 0),
        tmBillableCents:
            (tmBillableLabour[p.id] ?? 0) + (tmBillableMat[p.id] ?? 0),
        noChargeCents: (noChargeLabour[p.id] ?? 0) + (noChargeMat[p.id] ?? 0),
        needsReviewCount: needsReview[p.id] ?? 0,
        hasCustomLabourRate: customRate(p),
      ),
  ]..sort((a, b) => a.project.projectName.compareTo(b.project.projectName));
  return summaries;
}

/// Propagates the first error, stays loading until all inputs have data, then
/// builds. (Local copy — same shape as the helper in `invoice_providers.dart`
/// and `time_entry_providers.dart`.)
AsyncValue<R> _combine<R>(List<AsyncValue<Object?>> values, R Function() build) {
  for (final v in values) {
    if (v.hasError) {
      return AsyncValue.error(v.error!, v.stackTrace ?? StackTrace.current);
    }
  }
  if (values.any((v) => !v.hasValue)) return AsyncValue<R>.loading();
  return AsyncValue.data(build());
}
