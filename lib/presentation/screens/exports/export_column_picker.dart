import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/export/export_table.dart';
import '../../providers/export/export_column_selection.dart';

/// Dialog for choosing which of a report's columns are shown and exported.
///
/// Carries over the original app's "include these columns" idea, but driven by
/// the report's own [ExportColumn] list instead of a hardcoded checkbox map per
/// subject — a report declares its columns once and this picker follows.
///
/// [allColumns] is the report's full catalogue, not the currently visible
/// subset, so unticked columns remain reachable.
class ExportColumnPicker extends ConsumerWidget {
  const ExportColumnPicker({super.key, required this.allColumns});

  final List<ExportColumn> allColumns;

  static Future<void> show(
    BuildContext context, {
    required List<ExportColumn> allColumns,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => ExportColumnPicker(allColumns: allColumns),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(exportColumnSelectionProvider);
    final notifier = ref.read(exportColumnSelectionProvider.notifier);
    final defaults = [
      for (final c in allColumns)
        if (c.defaultOn) c.key
    ];
    final active = selection ?? defaults.toSet();

    return AlertDialog(
      title: const Text('Columns'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final column in allColumns)
              CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(column.label),
                value: active.contains(column.key),
                onChanged: (_) =>
                    notifier.toggle(column.key, defaults: defaults),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: notifier.reset,
          child: const Text('Reset'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
