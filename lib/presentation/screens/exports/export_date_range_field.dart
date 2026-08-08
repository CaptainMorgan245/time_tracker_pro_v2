import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/export/export_filter.dart';

/// The date-range control: a month stepper on top, custom start/end beneath.
///
/// The month row is the one shortcut worth having — a card statement cycles
/// monthly, so "June" is the question being asked most of the time. It snaps to
/// the calendar month's bounds rather than offering a menu of presets; anything
/// else the custom fields already cover.
///
/// Both halves write to the same [exportFilterProvider] range, so the label
/// above always reflects what's actually selected: pick a custom range and the
/// month label drops away.
class ExportDateRangeField extends ConsumerWidget {
  const ExportDateRangeField({super.key});

  static final DateFormat _month = DateFormat('MMMM yyyy');
  static final DateFormat _day = DateFormat('yyyy-MM-dd');

  Future<void> _pick(
    BuildContext context,
    WidgetRef ref, {
    required bool isStart,
  }) async {
    final filter = ref.read(exportFilterProvider);
    final initial = (isStart ? filter.start : filter.end) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      // No cap at today: a range may legitimately run to a month end that
      // hasn't arrived yet, which is exactly what the month picker produces.
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    final notifier = ref.read(exportFilterProvider.notifier);
    if (isStart) {
      notifier.setStart(picked);
    } else {
      notifier.setEnd(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(exportFilterProvider);
    final notifier = ref.read(exportFilterProvider.notifier);
    final theme = Theme.of(context);

    final label = filter.isWholeMonth && filter.start != null
        ? _month.format(filter.start!)
        : 'Custom range';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous month',
              onPressed: () => notifier.stepMonth(-1),
            ),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_month, size: 18),
                label: Text(label, overflow: TextOverflow.ellipsis),
                onPressed: () => notifier.setMonth(DateTime.now()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Next month',
              onPressed: () => notifier.stepMonth(1),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          filter.isWholeMonth
              ? 'Tap the month to jump to the current month'
              : 'Tap the month button to snap to the current month',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _DateField(
                label: 'Start',
                value: filter.start,
                format: _day,
                onTap: () => _pick(context, ref, isStart: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DateField(
                label: 'End',
                value: filter.end,
                format: _day,
                onTap: () => _pick(context, ref, isStart: false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.format,
    required this.onTap,
  });

  final String label;
  final DateTime? value;
  final DateFormat format;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          isDense: true,
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(value == null ? 'Any' : format.format(value!)),
      ),
    );
  }
}
