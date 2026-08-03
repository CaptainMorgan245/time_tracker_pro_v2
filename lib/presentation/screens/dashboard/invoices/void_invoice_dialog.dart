import 'package:flutter/material.dart';


class VoidInput {
  VoidInput({required this.reasonCode, this.notes});
  final String reasonCode;
  final String? notes;
}

const _reasons = <List<String>>[
  ['error', 'Created in error'],
  ['cancelled', 'Job cancelled'],
  ['duplicate', 'Duplicate'],
  ['reissued', 'Reissued / superseded'],
  ['other', 'Other'],
];

/// Void confirmation dialog: pick a reason + optional notes. Returns null on
/// cancel.
Future<VoidInput?> showVoidInvoiceDialog(BuildContext context) {
  return showDialog<VoidInput>(
    context: context,
    builder: (_) => const _VoidInvoiceDialog(),
  );
}

class _VoidInvoiceDialog extends StatefulWidget {
  const _VoidInvoiceDialog();
  @override
  State<_VoidInvoiceDialog> createState() => _VoidInvoiceDialogState();
}

class _VoidInvoiceDialogState extends State<_VoidInvoiceDialog> {
  String _reason = _reasons.first[0];
  final _notes = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Void Invoice'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('This marks the invoice as void. It cannot be undone.'),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _reason,
            isExpanded: true,
            decoration: const InputDecoration(
                labelText: 'Reason', border: OutlineInputBorder()),
            items: [
              for (final r in _reasons)
                DropdownMenuItem(value: r[0], child: Text(r[1])),
            ],
            onChanged: (v) => setState(() => _reason = v ?? _reason),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final notes = _notes.text.trim();
            Navigator.of(context).pop(
                VoidInput(reasonCode: _reason, notes: notes.isEmpty ? null : notes));
          },
          child: const Text('Void', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
