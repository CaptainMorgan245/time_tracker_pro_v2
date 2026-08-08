import 'package:flutter/material.dart';

import '../../../core/export/export_table.dart';
import 'export_format.dart';

/// Renders an [ExportTable] on screen.
///
/// This is the report itself, not a preview of a file: "show me expenses by
/// project for June" is answered here, and exporting is a separate action the
/// user may never take. What it renders is exactly what the CSV writes — same
/// table, same columns, same order — so the file can never disagree with the
/// screen.
///
/// Presentational only (takes the finished table, watches nothing), matching
/// how `StatementLedgerView` is built.
class ExportPreviewTable extends StatelessWidget {
  const ExportPreviewTable({super.key, required this.table});

  final ExportTable table;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (table.columns.isEmpty) {
      return const _Empty(
        icon: Icons.view_column_outlined,
        message: 'No columns selected.',
      );
    }
    if (table.isEmpty) {
      return const _Empty(
        icon: Icons.receipt_long_outlined,
        message: 'No expenses match this filter.',
      );
    }

    final bold = theme.textTheme.bodyMedium
        ?.copyWith(fontWeight: FontWeight.bold);

    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          headingRowHeight: 40,
          dataRowMinHeight: 36,
          dataRowMaxHeight: 52,
          columns: [
            for (final column in table.columns)
              DataColumn(
                numeric: isNumericColumn(column.type),
                label: Text(column.label, style: bold),
              ),
          ],
          rows: [
            for (final row in table.rows)
              DataRow(
                cells: [
                  for (final column in table.columns)
                    DataCell(Text(
                      formatExportCell(row[column.key], column.type),
                      overflow: TextOverflow.ellipsis,
                    )),
                ],
              ),
            if (table.totals.isNotEmpty) _totalsRow(table, bold),
          ],
        ),
      ),
    );
  }

  /// Mirrors the CSV service's totals convention: a value wherever the report
  /// supplied one, and `TOTAL` in the first column unless that column has a
  /// total of its own.
  DataRow _totalsRow(ExportTable table, TextStyle? bold) {
    return DataRow(
      cells: [
        for (var i = 0; i < table.columns.length; i++)
          DataCell(Text(
            table.totals.containsKey(table.columns[i].key)
                ? formatExportCell(
                    table.totals[table.columns[i].key], table.columns[i].type)
                : (i == 0 ? 'TOTAL' : ''),
            style: bold,
          )),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: theme.hintColor),
          const SizedBox(height: 8),
          Text(message, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
