import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/analytics_providers.dart';
import '../../../widgets/async_value_view.dart';
import 'analytics_format.dart';

/// The single landing-page card ("Project Financial Summary"). Financials are
/// per-project, never blended across projects, and are branched by pricing model
/// because fixed-price and T&M projects mean different things by "margin":
///
///   - **Fixed-Price** table: contract price − Contract Work cost = contract
///     margin; above-contract Billable work is shown separately as invoiced
///     extras and an extras margin. (Decisions B + D.)
///   - **Time & Materials** table: invoiced-to-date − T&M (Billable) cost =
///     margin; logged billable value is shown alongside. (Decision C.)
///
/// Both tables carry a **No Charge** figure (billable value deliberately not
/// charged — tracked, not counted as cost) and a **Review** count (entries whose
/// cost code is missing/unrecognised, excluded from every total until assigned).
/// Internal-coded work is overhead and excluded entirely. Sourced from
/// [financialSummaryProvider] — no inline card math.
class ProjectFinancialSummaryCard extends ConsumerWidget {
  const ProjectFinancialSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(analyticsSelectionProvider);
    final summaryA = ref.watch(financialSummaryProvider);
    final active = selection.reportType == AnalyticsReportType.activeProjects;

    return Card(
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text('Project Financial Summary',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const Divider(height: 20),
            AsyncValueView<FinancialSummary>(
              value: summaryA,
              builder: (summary) {
                var rows = summary.rows
                    .where((r) => active
                        ? r.project.isCompleted == 0
                        : r.project.isCompleted != 0)
                    .toList();
                if (selection.selectedProjectId != null) {
                  rows = rows
                      .where((r) => r.project.id == selection.selectedProjectId)
                      .toList();
                }
                rows.sort((a, b) =>
                    a.project.projectName.compareTo(b.project.projectName));

                if (rows.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(active
                        ? 'No active projects.'
                        : 'No completed projects.'),
                  );
                }

                final fixed = rows.where((r) => r.isFixed).toList();
                final tm = rows.where((r) => !r.isFixed).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (fixed.isNotEmpty) ...[
                      _sectionLabel(context, 'Fixed-Price Projects'),
                      const SizedBox(height: 6),
                      _FixedPriceTable(rows: fixed),
                    ],
                    if (fixed.isNotEmpty && tm.isNotEmpty)
                      const SizedBox(height: 20),
                    if (tm.isNotEmpty) ...[
                      _sectionLabel(context, 'Time & Materials Projects'),
                      const SizedBox(height: 6),
                      _TimeMaterialsTable(rows: tm),
                    ],
                    const SizedBox(height: 12),
                    const _Legend(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.bold),
      );
}

// ===========================================================================
// Fixed-price table
// ===========================================================================

class _FixedPriceTable extends StatelessWidget {
  const _FixedPriceTable({required this.rows});

  final List<FinancialSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowHeight: 38,
        dataRowMinHeight: 36,
        dataRowMaxHeight: 48,
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        columns: const [
          DataColumn(label: Text('Project')),
          DataColumn(label: Text('Client')),
          DataColumn(label: Text('Hours'), numeric: true),
          DataColumn(label: Text('Contract Price'), numeric: true),
          DataColumn(label: Text('Contract Cost'), numeric: true),
          DataColumn(label: Text('Contract Margin'), numeric: true),
          DataColumn(label: Text('Extras Inv.'), numeric: true),
          DataColumn(label: Text('Extras Margin'), numeric: true),
          DataColumn(label: Text('No Charge'), numeric: true),
          DataColumn(label: Text('Review'), numeric: true),
        ],
        rows: [
          for (final s in rows)
            DataRow(cells: [
              DataCell(_projectCell(context, s)),
              DataCell(Text(s.clientName)),
              DataCell(Text(s.totalHours.toStringAsFixed(1))),
              DataCell(Text(formatMoneyCents(s.contractValueCents))),
              DataCell(_costCell(formatMoneyCents(s.contractCostCents),
                  s.hasCustomLabourRate)),
              DataCell(_moneyColored(s.contractMarginCents)),
              DataCell(Text(formatMoneyCents(s.extrasInvoicedCents))),
              DataCell(_moneyColored(s.extrasMarginCents)),
              DataCell(Text(formatMoneyCents(s.noChargeCents))),
              DataCell(_reviewCell(s.needsReviewCount)),
            ]),
        ],
      ),
    );
  }
}

// ===========================================================================
// Time & Materials table
// ===========================================================================

class _TimeMaterialsTable extends StatelessWidget {
  const _TimeMaterialsTable({required this.rows});

  final List<FinancialSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowHeight: 38,
        dataRowMinHeight: 36,
        dataRowMaxHeight: 48,
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        columns: const [
          DataColumn(label: Text('Project')),
          DataColumn(label: Text('Client')),
          DataColumn(label: Text('Hours'), numeric: true),
          DataColumn(label: Text('Cost'), numeric: true),
          DataColumn(label: Text('Logged Billable'), numeric: true),
          DataColumn(label: Text('Invoiced-to-Date'), numeric: true),
          DataColumn(label: Text('Margin'), numeric: true),
          DataColumn(label: Text('No Charge'), numeric: true),
          DataColumn(label: Text('Review'), numeric: true),
        ],
        rows: [
          for (final s in rows)
            DataRow(cells: [
              DataCell(_projectCell(context, s)),
              DataCell(Text(s.clientName)),
              DataCell(Text(s.totalHours.toStringAsFixed(1))),
              DataCell(
                  _costCell(formatMoneyCents(s.tmCostCents), s.hasCustomLabourRate)),
              DataCell(Text(formatMoneyCents(s.loggedBillableCents))),
              DataCell(Text(formatMoneyCents(s.invoicedToDateCents))),
              DataCell(_moneyColored(s.tmMarginCents)),
              DataCell(Text(formatMoneyCents(s.noChargeCents))),
              DataCell(_reviewCell(s.needsReviewCount)),
            ]),
        ],
      ),
    );
  }
}

// ===========================================================================
// Shared cell helpers
// ===========================================================================

const _customRateMessage =
    'This project uses a custom hourly rate. Labour cost is calculated using '
    'the company burden rate.';

/// Project-name cell. For a custom-rate project it prepends a circled "?" icon
/// that is both hoverable (tooltip) and tappable (dialog) so the explanation is
/// reachable on desktop and tablet without relying on hover.
Widget _projectCell(BuildContext context, FinancialSummaryRow s) {
  final name = s.project.projectName;
  if (!s.hasCustomLabourRate) return Text(name);
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Tooltip(
        message: _customRateMessage,
        child: InkResponse(
          onTap: () => _showCustomRateInfo(context),
          radius: 16,
          child: Icon(Icons.help_outline, size: 18, color: Colors.blue.shade700),
        ),
      ),
      const SizedBox(width: 2),
      Flexible(child: Text(name)),
    ],
  );
}

void _showCustomRateInfo(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Custom hourly rate'),
      content: const Text(_customRateMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

/// A cost cell that, when the project uses a custom hourly rate, is shown in
/// blue with a tooltip explaining that cost still uses the company burden rate.
Widget _costCell(String value, bool custom) {
  if (!custom) return Text(value);
  return Tooltip(
    message: _customRateMessage,
    child: Text(
      value,
      style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600),
    ),
  );
}

/// Money value coloured by sign (red when negative), used for margin cells.
Widget _moneyColored(int cents) => Text(
      formatMoneyCents(cents),
      style: TextStyle(
        color: cents < 0 ? Colors.red.shade700 : Colors.green.shade800,
        fontWeight: FontWeight.w600,
      ),
    );

/// "Needs review" count cell: a red count when there is anything to fix, an
/// em-dash otherwise.
Widget _reviewCell(int count) {
  if (count == 0) return const Text('—');
  return Text(
    '$count',
    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600),
  );
}

/// Footnote explaining the non-obvious columns/exclusions.
class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: Colors.grey.shade700);
    return Text(
      'No Charge = billable value deliberately not charged (tracked, not a '
      'cost). Review = entries missing a cost code — assign one to include '
      'them. Internal-coded work is excluded as overhead.',
      style: style,
    );
  }
}
