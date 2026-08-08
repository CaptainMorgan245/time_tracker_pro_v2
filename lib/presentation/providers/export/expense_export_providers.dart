import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/billing_calc.dart' show costCodeCategoryLabel;
import '../../../core/export/export_table.dart';
import '../../../data/local/drift/app_database.dart';
import '../async_combine.dart';
import '../client_project_providers.dart';
import '../cost_entry_providers.dart';
import '../invoice_providers.dart' show invoicesStreamProvider;
import '../reference_data_providers.dart';
import 'export_column_selection.dart';
import 'export_filter.dart';

/// The **Expenses** report: one row per expense record, resolved against
/// projects, clients, cost codes and invoices, shaped as a format-neutral
/// [ExportTable].
///
/// Line-level, never aggregated — the job driving it is reconciling a card
/// statement, which is matched charge by charge; a summary would be useless for
/// that. Rows are ordered **oldest first**, the order a statement lists them
/// (the original app's report sorted newest-first, which is the wrong way round
/// for ticking off a statement).
///
/// **Raw cost only.** No markup or billable-value column: the marked-up figure
/// is a client-facing number and would give an accountant a second amount that
/// matches nothing on the card. Markup stays on the invoice documents.
///
/// All money is integer **cents** and stays that way — the renderers format.

// ===========================================================================
// Column catalogue
// ===========================================================================

/// Every column this report can produce, in display order, with the default-on
/// set chosen for statement reconciliation: what was bought, from whom, for
/// which project, and how much.
///
/// The rest are off by default rather than absent, so the column picker can
/// surface them without the report having to change.
const List<ExportColumn> kExpenseExportColumns = [
  ExportColumn(key: 'date', label: 'Date', type: ExportCellType.date),
  ExportColumn(key: 'project', label: 'Project', type: ExportCellType.text),
  ExportColumn(key: 'client', label: 'Client', type: ExportCellType.text),
  ExportColumn(key: 'vendor', label: 'Vendor', type: ExportCellType.text),
  ExportColumn(key: 'item', label: 'Item', type: ExportCellType.text),
  ExportColumn(
      key: 'description', label: 'Description', type: ExportCellType.text),
  ExportColumn(key: 'category', label: 'Category', type: ExportCellType.text),
  ExportColumn(key: 'cost', label: 'Cost', type: ExportCellType.moneyCents),
  ExportColumn(
    key: 'companyExpense',
    label: 'Company Expense',
    type: ExportCellType.boolean,
  ),
  ExportColumn(
    key: 'costCode',
    label: 'Cost Code',
    type: ExportCellType.text,
    defaultOn: false,
  ),
  ExportColumn(
    key: 'costCodeCategory',
    label: 'Cost Code Category',
    type: ExportCellType.text,
    defaultOn: false,
  ),
  ExportColumn(
    key: 'quantity',
    label: 'Quantity',
    type: ExportCellType.hours,
    defaultOn: false,
  ),
  ExportColumn(
    key: 'unit',
    label: 'Unit',
    type: ExportCellType.text,
    defaultOn: false,
  ),
  ExportColumn(
    key: 'vehicle',
    label: 'Vehicle',
    type: ExportCellType.text,
    defaultOn: false,
  ),
  ExportColumn(
    key: 'billed',
    label: 'Billed',
    type: ExportCellType.boolean,
    defaultOn: false,
  ),
  ExportColumn(
    key: 'invoice',
    label: 'Invoice #',
    type: ExportCellType.text,
    defaultOn: false,
  ),
];

// ===========================================================================
// The report
// ===========================================================================

/// The full expense table for the current [exportFilterProvider] selection —
/// every column, before the column picker narrows it.
///
/// Derived from the existing reactive streams, so it refreshes on its own as
/// expenses are added or edited; there is no separate "run the report" step.
final expenseExportTableProvider = Provider<AsyncValue<ExportTable>>((ref) {
  final filter = ref.watch(exportFilterProvider);
  final materialsA = ref.watch(materialsStreamProvider);
  final projectsA = ref.watch(projectsStreamProvider);
  final clientsA = ref.watch(clientsStreamProvider);
  final costCodesA = ref.watch(costCodesStreamProvider);
  final invoicesA = ref.watch(invoicesStreamProvider);

  return combineAsync(
    [materialsA, projectsA, clientsA, costCodesA, invoicesA],
    () => _buildExpenseTable(
      filter: filter,
      materials: materialsA.requireValue,
      projects: projectsA.requireValue,
      clients: clientsA.requireValue,
      costCodes: costCodesA.requireValue,
      invoices: invoicesA.requireValue,
    ),
  );
});

/// The expense table narrowed to the user's ticked columns — what the preview
/// renders and what the CSV action exports, so the file always matches the
/// screen exactly.
///
/// A null selection means the report's own defaults are in force.
final visibleExpenseExportTableProvider =
    Provider<AsyncValue<ExportTable>>((ref) {
  final selection = ref.watch(exportColumnSelectionProvider);
  return ref.watch(expenseExportTableProvider).whenData(
        (table) => table.selectColumns(selection ?? table.defaultColumnKeys),
      );
});

/// The distinct expense categories actually present on non-deleted expenses,
/// sorted case-insensitively — the filter bar's Category options.
///
/// Read off the records rather than the `expense_categories` table on purpose:
/// filtering by a category nothing is filed under would only ever return an
/// empty report.
final expenseCategoryOptionsProvider =
    Provider<AsyncValue<List<String>>>((ref) {
  return ref.watch(materialsStreamProvider).whenData((materials) {
    final names = <String>{};
    for (final m in materials) {
      if (m.isDeleted != 0) continue;
      final c = m.expenseCategory?.trim();
      if (c != null && c.isNotEmpty) names.add(c);
    }
    return names.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  });
});

// ===========================================================================
// Derivation
// ===========================================================================

final DateFormat _subtitleDate = DateFormat('d MMM yyyy');

ExportTable _buildExpenseTable({
  required ExportFilter filter,
  required List<DbMaterial> materials,
  required List<DbProject> projects,
  required List<DbClient> clients,
  required List<DbCostCode> costCodes,
  required List<DbInvoice> invoices,
}) {
  final projectById = {for (final p in projects) p.id: p};
  final clientById = {for (final c in clients) c.id: c};
  final costCodeById = {for (final c in costCodes) c.id: c};
  final invoiceNumberById = {for (final i in invoices) i.id: i.invoiceNumber};

  // Whole-day bounds: an expense timestamped mid-afternoon on the end date is
  // still inside the period.
  final startBound = filter.start == null
      ? null
      : DateTime(filter.start!.year, filter.start!.month, filter.start!.day);
  final endBound = filter.end == null
      ? null
      : DateTime(filter.end!.year, filter.end!.month, filter.end!.day,
          23, 59, 59);
  final hasDateFilter = startBound != null || endBound != null;

  final categoryFilter = filter.expenseCategory?.trim().toLowerCase();

  final kept = <_ExpenseRecord>[];
  var totalCents = 0;
  var undatedSkipped = 0;

  for (final m in materials) {
    if (m.isDeleted != 0) continue;

    switch (filter.scope) {
      case ExpenseScope.projectOnly:
        if (m.isCompanyExpense != 0) continue;
        break;
      case ExpenseScope.companyOnly:
        if (m.isCompanyExpense == 0) continue;
        break;
      case ExpenseScope.all:
        break;
    }

    final project = projectById[m.projectId];
    if (filter.projectId != null && m.projectId != filter.projectId) continue;
    if (filter.clientId != null && project?.clientId != filter.clientId) {
      continue;
    }

    if (filter.costCodeId != null) {
      if (filter.costCodeId == -1) {
        if (m.costCodeId != null) continue;
      } else if (m.costCodeId != filter.costCodeId) {
        continue;
      }
    }

    if (categoryFilter != null && categoryFilter.isNotEmpty) {
      if ((m.expenseCategory ?? '').trim().toLowerCase() != categoryFilter) {
        continue;
      }
    }

    final date = m.purchaseDate == null
        ? null
        : DateTime.tryParse(m.purchaseDate!);
    if (hasDateFilter) {
      // An expense with no usable purchase date can't be placed in a period, so
      // it's excluded whenever one is set — and counted, so the report can say
      // so rather than silently under-reporting.
      if (date == null) {
        undatedSkipped++;
        continue;
      }
      if (startBound != null && date.isBefore(startBound)) continue;
      if (endBound != null && date.isAfter(endBound)) continue;
    }

    kept.add(_ExpenseRecord(m, date));
    totalCents += m.cost;
  }

  // Oldest first — statement order. Undated rows (only possible with no date
  // filter) sort to the end. `id` breaks ties so the order is stable between
  // rebuilds.
  kept.sort((a, b) {
    final ad = a.date;
    final bd = b.date;
    if (ad == null && bd == null) return a.material.id.compareTo(b.material.id);
    if (ad == null) return 1;
    if (bd == null) return -1;
    final byDate = ad.compareTo(bd);
    return byDate != 0 ? byDate : a.material.id.compareTo(b.material.id);
  });

  final rows = <ExportRow>[];
  for (final record in kept) {
    final m = record.material;
    final project = projectById[m.projectId];
    final costCode = m.costCodeId == null ? null : costCodeById[m.costCodeId];
    rows.add(ExportRow({
      'date': record.date,
      'project': project?.projectName ?? 'Unknown',
      'client': project == null
          ? 'Unknown'
          : (clientById[project.clientId]?.name ?? 'Unknown'),
      'vendor': m.vendorOrSubtrade,
      'item': m.itemName,
      'description': m.description,
      'category': m.expenseCategory,
      'cost': m.cost,
      'companyExpense': m.isCompanyExpense != 0,
      'costCode': m.costCodeId == null ? 'No Cost Code' : costCode?.name,
      'costCodeCategory':
          m.costCodeId == null ? null : costCodeCategoryLabel(costCode?.category),
      'quantity': m.quantity,
      'unit': m.unit,
      'vehicle': m.vehicleDesignation,
      'billed': m.isBilled != 0,
      'invoice': m.invoiceId == null ? null : invoiceNumberById[m.invoiceId],
    }));
  }

  return ExportTable(
    title: _titleFor(filter.scope),
    subtitle: _subtitle(
      filter: filter,
      projectById: projectById,
      clientById: clientById,
      costCodeById: costCodeById,
      undatedSkipped: undatedSkipped,
    ),
    columns: kExpenseExportColumns,
    rows: rows,
    totals: {'cost': totalCents},
  );
}

/// Pairs a record with its parsed date so the sort doesn't re-parse per compare.
class _ExpenseRecord {
  const _ExpenseRecord(this.material, this.date);
  final DbMaterial material;
  final DateTime? date;
}

String _titleFor(ExpenseScope scope) {
  switch (scope) {
    case ExpenseScope.all:
      return 'All Expenses';
    case ExpenseScope.projectOnly:
      return 'Expenses by Project';
    case ExpenseScope.companyOnly:
      return 'Company Expenses';
  }
}

/// One line describing what the reader is looking at: period, then whichever
/// filters are actually narrowing it. Shown on screen and in the PDF header;
/// never written into the CSV, which stays a clean grid.
String _subtitle({
  required ExportFilter filter,
  required Map<int, DbProject> projectById,
  required Map<int, DbClient> clientById,
  required Map<int, DbCostCode> costCodeById,
  required int undatedSkipped,
}) {
  final parts = <String>[_periodLabel(filter)];

  switch (filter.scope) {
    case ExpenseScope.all:
      parts.add('Project + company');
      break;
    case ExpenseScope.projectOnly:
      parts.add('Project expenses');
      break;
    case ExpenseScope.companyOnly:
      parts.add('Company expenses');
      break;
  }

  if (filter.clientId != null) {
    parts.add(clientById[filter.clientId]?.name ?? 'Unknown client');
  }
  if (filter.projectId != null) {
    parts.add(projectById[filter.projectId]?.projectName ?? 'Unknown project');
  }
  if (filter.costCodeId != null) {
    parts.add(filter.costCodeId == -1
        ? 'No cost code'
        : (costCodeById[filter.costCodeId]?.name ?? 'Unknown cost code'));
  }
  final category = filter.expenseCategory?.trim();
  if (category != null && category.isNotEmpty) parts.add(category);

  if (undatedSkipped > 0) {
    parts.add(undatedSkipped == 1
        ? '1 undated expense not shown'
        : '$undatedSkipped undated expenses not shown');
  }

  return parts.join(' · ');
}

String _periodLabel(ExportFilter filter) {
  final start = filter.start;
  final end = filter.end;
  if (start == null && end == null) return 'All dates';
  if (filter.isWholeMonth) return DateFormat('MMMM yyyy').format(start!);
  if (start == null) return 'Up to ${_subtitleDate.format(end!)}';
  if (end == null) return 'From ${_subtitleDate.format(start)}';
  return '${_subtitleDate.format(start)} – ${_subtitleDate.format(end)}';
}
