import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


/// Result of the Record Payment dialog.
class PaymentInput {
  PaymentInput({
    required this.amount,
    required this.method,
    this.reference,
    required this.date,
    this.notes,
  });
  final double amount;
  final String method;
  final String? reference;
  final DateTime date;
  final String? notes;
}

/// Record-payment dialog (ported from v1). Amount pre-fills to the full total;
/// a partial banner shows when less is entered. Returns null on cancel.
Future<PaymentInput?> showRecordPaymentDialog(
  BuildContext context, {
  required double total,
}) {
  return showDialog<PaymentInput>(
    context: context,
    builder: (_) => _RecordPaymentDialog(total: total),
  );
}

class _RecordPaymentDialog extends StatefulWidget {
  const _RecordPaymentDialog({required this.total});
  final double total;

  @override
  State<_RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<_RecordPaymentDialog> {
  late final TextEditingController _amount =
      TextEditingController(text: widget.total.toStringAsFixed(2));
  final _reference = TextEditingController();
  final _notes = TextEditingController();
  String _method = 'etransfer';
  DateTime _date = DateTime.now();

  static final _currency = NumberFormat.currency(symbol: '\$');

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    _notes.dispose();
    super.dispose();
  }

  double get _entered =>
      double.tryParse(_amount.text.replaceAll(',', '')) ?? 0.0;
  bool get _isPartial => _entered < widget.total - 0.005;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final refLabel = _method == 'cheque' ? 'Cheque #' : 'Confirmation #';
    return AlertDialog(
      title: const Text('Record Payment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: [
                for (final m in const [
                  ['cheque', 'Cheque'],
                  ['cash', 'Cash'],
                  ['etransfer', 'E-Transfer'],
                ])
                  ChoiceChip(
                    label: Text(m[1]),
                    selected: _method == m[0],
                    onSelected: (_) => setState(() => _method = m[0]),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_method != 'cash')
              // Cheque number / e-transfer confirmation number. Reproduced
              // EXACTLY as the bank issued it, so no capitalization styling at
              // all: these are arbitrary mixed-case alphanumeric strings, and
              // `TextCapitalization.characters` locks the soft keyboard into
              // caps for every keystroke — the user can't hold a lowercase
              // character even deliberately. Suggestions stay off so the code
              // can't be "corrected" into a word either.
              TextField(
                controller: _reference,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                    labelText: refLabel, border: const OutlineInputBorder()),
              ),
            if (_method != 'cash') const SizedBox(height: 12),
            TextField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Amount Received',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            if (_isPartial && _entered > 0) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Partial payment — Remaining: '
                  '${_currency.format(widget.total - _entered)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                    labelText: 'Payment Date', border: OutlineInputBorder()),
                child: Text(DateFormat('MMM d, yyyy').format(_date)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                  labelText: 'Notes (optional)', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final ref = _reference.text.trim();
            final notes = _notes.text.trim();
            Navigator.of(context).pop(PaymentInput(
              amount: _entered,
              method: _method,
              reference: ref.isEmpty ? null : ref,
              date: _date,
              notes: notes.isEmpty ? null : notes,
            ));
          },
          child: Text(_isPartial && _entered > 0
              ? 'Record Partial Payment'
              : 'Mark Paid'),
        ),
      ],
    );
  }
}
