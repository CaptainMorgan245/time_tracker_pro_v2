import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/invoice_calc.dart';
import '../../../../data/local/drift/app_database.dart';
import '../../../providers/final_invoice_providers.dart';
import '../../../providers/invoice_edit_providers.dart';
import '../../../providers/invoice_providers.dart';
import '../../../widgets/async_value_view.dart';

final _currency = NumberFormat.currency(symbol: '\$');
final _dateFmt = DateFormat('MMMM d, yyyy');

const _typeOptions = <List<String>>[
  ['deposit', 'Deposit'],
  ['progress', 'Progress Draw'],
  ['final', 'Final Invoice'],
];

const _typeLabels = {
  'deposit': 'Deposit',
  'progress': 'Progress Draw',
  'final': 'Final Invoice',
  'extras': 'Time & Materials',
  'chargeable': 'Chargeable Extra',
  'addendum': 'Addendum',
};

/// **Edit Details** — the metadata-only editor used once an invoice is paid in
/// full.
///
/// The billed amount can never change after payment, so this screen has no money
/// field at all and saves through [InvoiceEditActions.updateInvoiceMetadata],
/// whose signature cannot carry one. Everything monetary — subtotal, taxes,
/// discount, total, line items — is shown read-only for reference.
///
/// Deliberately a separate screen rather than a "locked" mode bolted onto the
/// fixed-price and T&M invoice screens: both of those derive and rewrite totals
/// on submit, which is precisely what must not happen here, and the T&M screen's
/// entire purpose (line selection) has no place in a metadata edit.
///
/// The one non-obvious control is the type selector. An invoice sent and paid as
/// a progress draw when it should have been the contract's final invoice has to
/// be correctable after the fact — but retyping to `final` changes how the
/// invoice *renders* (the detail screen and PDF switch to the reconciled
/// contract statement), so the option is offered only when that reconciliation
/// matches what was actually billed. See [finalRetypeBlocker].
class EditInvoiceDetailsScreen extends ConsumerStatefulWidget {
  const EditInvoiceDetailsScreen({super.key, required this.invoiceId});

  final int invoiceId;

  @override
  ConsumerState<EditInvoiceDetailsScreen> createState() =>
      _EditInvoiceDetailsScreenState();
}

class _EditInvoiceDetailsScreenState
    extends ConsumerState<EditInvoiceDetailsScreen> {
  final _po = TextEditingController();
  final _description = TextEditingController();
  final _notes = TextEditingController();
  final _internalNotes = TextEditingController();

  bool _seeded = false;
  String? _type;
  DateTime? _date;

  @override
  void dispose() {
    _po.dispose();
    _description.dispose();
    _notes.dispose();
    _internalNotes.dispose();
    super.dispose();
  }

  /// One-time seed from the invoice being edited.
  void _maybeSeed(DbInvoice inv) {
    if (_seeded) return;
    _seeded = true;
    _type = inv.invoiceType;
    _date = DateTime.tryParse(inv.invoiceDate) ?? DateTime.now();
    _po.text = inv.poNumber ?? '';
    _description.text = inv.workDescription ?? '';
    _notes.text = inv.notes ?? '';
    _internalNotes.text = inv.internalNotes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final detailA = ref.watch(invoiceDetailProvider(widget.invoiceId));
    final busy = ref.watch(invoiceEditActionsProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Invoice Details')),
      body: AsyncValueView<InvoiceDetailData?>(
        value: detailA,
        builder: (data) {
          if (data == null) {
            return const Center(child: Text('Invoice not found.'));
          }
          _maybeSeed(data.invoice);
          return _form(context, data, busy);
        },
      ),
    );
  }

  Widget _form(BuildContext context, InvoiceDetailData data, bool busy) {
    final inv = data.invoice;
    // Reconciliation this invoice WOULD state if retyped final — itself
    // excluded, so it never reconciles against itself.
    final statement = ref
        .watch(finalInvoiceStatementProvider(finalInvoiceParamsFor(inv)))
        .asData
        ?.value;
    final canRetype = contractInvoiceTypes.contains(inv.invoiceType);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _lockedNotice(),
              const SizedBox(height: 12),
              _frozenAmounts(inv, data),
              const SizedBox(height: 12),
              if (canRetype) ...[
                _typeSelector(inv, statement),
                const SizedBox(height: 12),
              ],
              _dateField(context),
              const SizedBox(height: 12),
              // A PO number is a client-supplied code reproduced exactly as
              // issued — arbitrary mixed case, so no capitalization styling.
              TextField(
                controller: _po,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec('PO Number (optional)'),
              ),
              const SizedBox(height: 12),
              // `autocorrect` and `enableSuggestions` must BOTH be off — on
              // Android they are independent, and with only autocorrect off
              // Gboard still commits a highlighted candidate on the spacebar,
              // silently altering text that gets printed for a client.
              TextField(
                controller: _description,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec('Work Performed (optional)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notes,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec('Notes (printed on invoice)',
                    helper: 'Printed whenever filled in.'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _internalNotes,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec('Internal Notes (optional)',
                    helper: 'Never printed. Type changes are recorded here.'),
              ),
            ],
          ),
        ),
        _footer(context, inv, busy),
      ],
    );
  }

  Widget _lockedNotice() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          border: Border(left: BorderSide(color: Colors.blue.shade700, width: 4)),
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_outline, size: 18, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'This invoice is paid in full. The billed amount is locked and '
                'cannot be changed. Type, date and notes remain editable.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      );

  /// The frozen figures, for reference only — no control here writes them.
  Widget _frozenAmounts(DbInvoice inv, InvoiceDetailData data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Billed Amount (locked)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _readonlyRow('Subtotal', inv.subtotal),
            if (inv.discountAmount != 0)
              _readonlyRow('Discount', -inv.discountAmount),
            if ((inv.tax1Rate ?? 0) != 0)
              _readonlyRow('${inv.tax1Name ?? 'Tax 1'} '
                  '(${inv.tax1Rate}%)', inv.tax1Amount),
            if ((inv.tax2Rate ?? 0) != 0)
              _readonlyRow('${inv.tax2Name ?? 'Tax 2'} '
                  '(${inv.tax2Rate}%)', inv.tax2Amount),
            const Divider(),
            _readonlyRow('Total', inv.totalAmount, bold: true),
            _readonlyRow('Paid', data.paidCents),
          ],
        ),
      ),
    );
  }

  static Widget _readonlyRow(String label, int cents, {bool bold = false}) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: Colors.grey.shade800,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(_currency.format(cents / 100), style: style),
        ],
      ),
    );
  }

  /// Type chips. `final` is offered only when retyping would still display the
  /// amount actually billed — otherwise it is disabled with the reason.
  Widget _typeSelector(DbInvoice inv, FinalInvoiceStatement? statement) {
    final blocker = finalRetypeBlocker(inv, statement);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Invoice Type',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in _typeOptions)
                  _typeChip(t[0], t[1], blocker: blocker),
              ],
            ),
            if (blocker != null && _type != 'final') ...[
              const SizedBox(height: 8),
              Text(
                'Final Invoice unavailable: $blocker',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _typeChip(String value, String label, {required String? blocker}) {
    // Only the `final` option is gated; deposit ↔ progress are interchangeable
    // labels over the same contract draw and change nothing about the figures.
    final disabled = value == 'final' && blocker != null;
    final chip = ChoiceChip(
      label: Text(label),
      selected: _type == value,
      onSelected: disabled ? null : (_) => setState(() => _type = value),
    );
    return disabled ? Tooltip(message: blocker, child: chip) : chip;
  }

  Widget _dateField(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) setState(() => _date = picked);
      },
      child: InputDecorator(
        decoration: _dec('Invoice Date').copyWith(
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(_date == null ? '' : _dateFmt.format(_date!)),
      ),
    );
  }

  Widget _footer(BuildContext context, DbInvoice inv, bool busy) {
    return Material(
      elevation: 8,
      // Pushed route — without this the button renders under the system
      // navigation bar on tablet.
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: busy ? null : () => _save(context, inv),
              icon: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(busy ? 'Saving…' : 'Save Changes'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, DbInvoice inv) async {
    String? trimmed(TextEditingController c) {
      final v = c.text.trim();
      return v.isEmpty ? null : v;
    }

    await ref.read(invoiceEditActionsProvider.notifier).updateInvoiceMetadata(
          original: inv,
          invoiceType: _type ?? inv.invoiceType,
          poNumber: trimmed(_po),
          workDescription: trimmed(_description),
          notes: trimmed(_notes),
          internalNotes: trimmed(_internalNotes),
          date: _date ?? DateTime.now(),
        );
    if (!context.mounted) return;

    final s = ref.read(invoiceEditActionsProvider);
    if (s.hasError) {
      final msg = s.error is InvoiceEditException
          ? (s.error as InvoiceEditException).message
          : 'Failed to save changes: ${s.error}';
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Invoice details updated.'),
      backgroundColor: Colors.green,
    ));
    Navigator.of(context).pop(); // back to detail; streams refresh it
  }

  static InputDecoration _dec(String label, {String? helper}) => InputDecoration(
        labelText: label,
        helperText: helper,
        border: const OutlineInputBorder(),
        filled: true,
      );
}

/// Human label for an invoice type, shared with the close-out prompt.
String invoiceTypeLabel(String type) => _typeLabels[type] ?? type;
