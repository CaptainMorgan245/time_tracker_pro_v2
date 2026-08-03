import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Start/End date fields (tap to open a date picker) for the Projects
/// Disbursement view. Laid out in a `Row` so it fits comfortably on a 7" tablet.
class PayrollDateRangeFields extends StatelessWidget {
  const PayrollDateRangeFields({
    super.key,
    required this.start,
    required this.end,
    required this.onStart,
    required this.onEnd,
  });

  final DateTime start;
  final DateTime end;
  final ValueChanged<DateTime> onStart;
  final ValueChanged<DateTime> onEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _field(context, 'Start Date', start, onStart)),
        const SizedBox(width: 8),
        Expanded(child: _field(context, 'End Date', end, onEnd)),
      ],
    );
  }

  Widget _field(
    BuildContext context,
    String label,
    DateTime value,
    ValueChanged<DateTime> onPick,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) onPick(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        child: Text(DateFormat('MMM d, yyyy').format(value)),
      ),
    );
  }
}
