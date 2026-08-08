import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/export/export_table.dart';
import '../../providers/export/csv_export_controller.dart';
import '../../providers/export/expense_export_providers.dart';
import '../../providers/export/export_filter.dart';
import '../../widgets/async_value_view.dart';
import 'export_action_bar.dart';
import 'export_column_picker.dart';
import 'export_filter_bar.dart';
import 'export_format.dart';
import 'export_preview_table.dart';

/// **Expenses** — a viewable report first, an export second.
///
/// The table on screen is the deliverable: "show me expenses by project for
/// June" is answered without exporting anything. The button in the bottom bar
/// then writes exactly what's displayed — same rows, same columns, same order —
/// so there is no way for the file and the screen to disagree.
///
/// Everything on screen derives from [exportFilterProvider] through
/// [visibleExpenseExportTableProvider]; the screen holds no state of its own and
/// there is no "run report" step.
class ExpenseExportScreen extends ConsumerWidget {
  const ExpenseExportScreen({super.key});

  /// Fires the CSV write. Deliberately not `async` and never awaited before
  /// reaching the platform helper: on web the save picker has to open inside
  /// the click gesture, so nothing may run ahead of it.
  void _export(WidgetRef ref, ExportTable table) {
    final filter = ref.read(exportFilterProvider);
    ref.read(csvExportControllerProvider.notifier).export(
          table: table,
          fileName: buildCsvFileName(
            stem: table.title,
            start: filter.start,
            end: filter.end,
            now: DateTime.now(),
          ),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableA = ref.watch(visibleExpenseExportTableProvider);
    final exportState = ref.watch(csvExportControllerProvider);
    final table = tableA.value;

    // Report the outcome of a write once, then return the controller to idle so
    // an unrelated rebuild can't re-announce it.
    ref.listen<AsyncValue<String?>>(csvExportControllerProvider, (_, next) {
      if (next.isLoading) return;
      if (next.hasError) {
        _snack(context, 'Export failed: ${next.error}', error: true);
        ref.read(csvExportControllerProvider.notifier).reset();
        return;
      }
      final fileName = next.value;
      // Null means idle, or that the user dismissed the web save dialog —
      // neither is worth a message.
      if (fileName == null) return;
      _snack(context, 'Saved $fileName');
      ref.read(csvExportControllerProvider.notifier).reset();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(table?.title ?? 'Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_column_outlined),
            tooltip: 'Columns',
            onPressed: () => ExportColumnPicker.show(
              context,
              allColumns: kExpenseExportColumns,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: ExportFilterBar(),
          ),
          if (table?.subtitle != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Text(
                table!.subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: AsyncValueView<ExportTable>(
              value: tableA,
              builder: (data) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: ExportPreviewTable(table: data),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ExportActionBar(
        summary: _summary(table),
        busy: exportState.isLoading,
        onExport: (table == null || table.isEmpty || table.columns.isEmpty)
            ? null
            : () => _export(ref, table),
      ),
    );
  }

  String _summary(ExportTable? table) {
    if (table == null) return 'Loading…';
    final rows = table.rowCount == 1 ? '1 row' : '${table.rowCount} rows';
    final total = table.totals['cost'];
    if (total == null) return rows;
    return '$rows · ${formatExportCell(total, ExportCellType.moneyCents)}';
  }

  void _snack(BuildContext context, String message, {bool error = false}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red : null,
    ));
  }
}
