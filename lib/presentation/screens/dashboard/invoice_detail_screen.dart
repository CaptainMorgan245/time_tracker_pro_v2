import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/final_invoice_providers.dart';
import '../../providers/invoice_edit_providers.dart';
import '../../providers/invoice_providers.dart';
import '../../services/invoice_pdf_service.dart';
import '../../widgets/async_value_view.dart';
import '../../widgets/final_invoice_statement_view.dart';
import '../pdf_preview_screen.dart';
import 'invoices/close_out_contract_dialog.dart';
import 'invoices/edit_invoice_details_screen.dart';
import 'invoices/fixed_price_invoice_screen.dart';
import 'invoices/record_payment_dialog.dart';
import 'invoices/time_materials_invoice_screen.dart';
import 'invoices/void_invoice_dialog.dart';

final _currency = NumberFormat.currency(symbol: '\$');
String _fmtDate(String? iso) {
  if (iso == null) return '';
  final d = DateTime.tryParse(iso);
  return d == null ? '' : DateFormat('MMMM d, yyyy').format(d);
}

const _typeLabels = {
  'progress': 'Progress Draw',
  'chargeable': 'Chargeable Extra',
  'addendum': 'Addendum',
  'deposit': 'Deposit',
  'extras': 'Time & Materials',
  'final': 'Final Invoice',
};

/// Document-style invoice view + action bar. Aggregate PDF export wired via
/// [InvoicePdfService]; invoice editing still deferred (Phase 2).
class InvoiceDetailScreen extends ConsumerWidget {
  const InvoiceDetailScreen({super.key, required this.invoiceId});
  final int invoiceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailA = ref.watch(invoiceDetailProvider(invoiceId));
    return Scaffold(
      appBar: AppBar(
        title: Text(detailA.asData?.value?.invoice.invoiceNumber ?? 'Invoice'),
      ),
      body: AsyncValueView<InvoiceDetailData?>(
        value: detailA,
        builder: (data) {
          if (data == null) {
            return const Center(child: Text('Invoice not found.'));
          }
          return Column(
            children: [
              Expanded(child: _InvoiceView(data: data)),
              _ActionBar(data: data),
            ],
          );
        },
      ),
    );
  }
}

class _InvoiceView extends ConsumerWidget {
  const _InvoiceView({required this.data});
  final InvoiceDetailData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inv = data.invoice;
    final c = data.company;
    // A final invoice presents the reconciled contract statement in place of the
    // contract-summary and totals blocks (Balance Due there *is* its total).
    final statement = inv.invoiceType == 'final'
        ? ref
            .watch(finalInvoiceStatementProvider(finalInvoiceParamsFor(inv)))
            .asData
            ?.value
        : null;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (inv.invoiceType == 'extras') _DriftNotice(invoice: inv),
        // Header
        _card([
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c?.companyName ?? '',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    if (c?.companyAddress != null) Text(c!.companyAddress!),
                    Text([c?.companyCity, c?.companyProvince, c?.companyPostalCode]
                        .where((e) => e != null && e.isNotEmpty)
                        .join(', ')),
                    if (c?.companyPhone != null) Text('Tel: ${c!.companyPhone}'),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('INVOICE',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  _StatusChip(status: data.status),
                  const SizedBox(height: 8),
                  Text('${_typeLabels[inv.invoiceType] ?? inv.invoiceType}'
                      '  ${inv.invoiceNumber}'),
                  Text(_fmtDate(inv.invoiceDate)),
                  if (inv.poNumber != null) Text('PO #: ${inv.poNumber}'),
                ],
              ),
            ],
          ),
        ]),
        // Bill to / project
        _card([
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bill To',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.clientName),
                    if (data.projectCity != null) Text(data.projectCity!),
                    if (data.clientPhone != null) Text(data.clientPhone!),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Project',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(data.projectName),
                    if (inv.projectAddress != null) Text(inv.projectAddress!),
                  ],
                ),
              ),
            ],
          ),
        ]),
        if (statement == null && data.isFixedPrice) _contractSummary(),
        if ((inv.workDescription ?? '').isNotEmpty)
          _card([
            const Text('Work Performed',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(inv.workDescription!),
          ]),
        // Totals — or, for a final invoice, the contract statement.
        if (statement != null)
          _card([
            const Text('Contract Statement',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            FinalInvoiceStatementView(statement: statement),
          ])
        else
          _card([_totals()]),
        // Payment info
        if (data.paidCents > 0) _paymentInfo(),
        if ((inv.notes ?? '').isNotEmpty)
          _card([
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(inv.notes!),
          ]),
        if ((inv.internalNotes ?? '').isNotEmpty)
          _card([
            const Text('Internal Notes (not printed)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(inv.internalNotes!),
          ]),
        if (inv.isDeleted != 0) _voidInfo(),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _contractSummary() {
    return _card([
      const Text('Contract Summary',
          style: TextStyle(fontWeight: FontWeight.bold)),
      _row('Contract Value', _currency.format(data.contractValue)),
      _row('Previously Billed', _currency.format(data.totalBilled)),
      _row('GST Collected', _currency.format(data.totalGstCollected)),
      const Divider(),
      _row('Balance Remaining', _currency.format(data.remaining), bold: true),
    ]);
  }

  Widget _totals() {
    final inv = data.invoice;
    return Column(
      children: [
        if (inv.invoiceType == 'extras' && inv.labourSubtotal > 0)
          _row('Labour', _currency.format(inv.labourSubtotal / 100)),
        if (inv.invoiceType == 'extras' && inv.materialsSubtotal > 0)
          _row('Materials', _currency.format(inv.materialsSubtotal / 100)),
        _row('Subtotal', _currency.format(inv.subtotal / 100), bold: true),
        if (inv.discountAmount > 0)
          _row(inv.discountDescription ?? 'Discount',
              '-${_currency.format(inv.discountAmount / 100)}'),
        if (inv.tax1Amount > 0)
          _row('${inv.tax1Name ?? 'GST'} (${(inv.tax1Rate ?? 0).toStringAsFixed(1)}%)',
              _currency.format(inv.tax1Amount / 100)),
        if (inv.tax2Amount > 0)
          _row('${inv.tax2Name ?? 'PST'} (${(inv.tax2Rate ?? 0).toStringAsFixed(1)}%)',
              _currency.format(inv.tax2Amount / 100)),
        const Divider(),
        _row('TOTAL DUE', _currency.format(inv.totalAmount / 100), bold: true),
      ],
    );
  }

  Widget _paymentInfo() {
    final payments = data.payments.where((p) => p.isVoid == 0).toList()
      ..sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
    final multiple = payments.length > 1;
    return _card([
      Text(multiple ? 'Payments' : 'Payment',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      for (final p in payments) ...[
        if (multiple) const Divider(),
        if (p.paymentMethod != null) _row('Method', p.paymentMethod!),
        _row('Amount Paid', _currency.format(p.amount / 100)),
        _row('Date', _fmtDate(p.paymentDate)),
        if (p.paymentReference != null) _row('Reference', p.paymentReference!),
        if ((p.paymentNotes ?? '').isNotEmpty) _row('Notes', p.paymentNotes!),
      ],
      if (multiple) ...[
        const Divider(),
        _row('Total Paid', _currency.format(data.paidCents / 100), bold: true),
      ],
      if (data.balanceDue > 0.005)
        _row('Balance Due', _currency.format(data.balanceDue), bold: true),
    ]);
  }

  Widget _voidInfo() {
    final inv = data.invoice;
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('VOID', style: TextStyle(fontWeight: FontWeight.bold)),
            if (inv.deletedReasonCode != null)
              Text('Reason: ${inv.deletedReasonCode}'),
            if (inv.deletedDate != null) Text('Voided: ${_fmtDate(inv.deletedDate)}'),
            if ((inv.deletedNotes ?? '').isNotEmpty) Text(inv.deletedNotes!),
          ],
        ),
      ),
    );
  }

  static Widget _card(List<Widget> children) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ),
      );

  static Widget _row(String label, String value, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}

class _ActionBar extends ConsumerWidget {
  const _ActionBar({required this.data});
  final InvoiceDetailData data;

  /// Opens the in-app preview as a pushed route, so the user can close it and
  /// come back. Printing happens from inside that preview's action bar rather
  /// than jumping straight to the platform print UI, which offered no way back.
  Future<void> _printPdf(
      BuildContext context, FinalInvoiceStatement? statement) async {
    try {
      final bytes = await InvoicePdfService.build(data, statement: statement);
      if (!context.mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(
          title: 'Invoice ${data.invoice.invoiceNumber}',
          fileName: 'Invoice_${data.invoice.invoiceNumber}.pdf',
          bytes: bytes,
        ),
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not generate PDF: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  /// Routes to the full editor or the metadata-only one, per the invoice's
  /// [InvoiceEditScope]. A paid invoice keeps an Edit button — it just lands on
  /// the screen that can't touch money.
  void _editInvoice(BuildContext context, InvoiceEditScope scope) {
    final inv = data.invoice;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => switch (scope) {
        InvoiceEditScope.metadataOnly =>
          EditInvoiceDetailsScreen(invoiceId: inv.id),
        _ => inv.invoiceType == 'extras'
            ? TimeMaterialsInvoiceScreen(
                projectId: inv.projectId, editingInvoiceId: inv.id)
            : FixedPriceInvoiceScreen(
                projectId: inv.projectId, editingInvoiceId: inv.id),
      },
    ));
  }

  /// Mark Sent, first checking whether this invoice closes out its fixed-price
  /// contract. If it does, offer to retype it as the final invoice before it
  /// goes out — the cheap moment to fix what otherwise has to be corrected after
  /// the invoice has been sent and paid.
  ///
  /// "Mark as Final" here is a type-only change routed through
  /// [InvoiceEditActions.updateInvoiceMetadata], so it cannot alter the billed
  /// amount. That is safe precisely because the prompt's trigger condition is
  /// that billing already reaches the contract total.
  Future<void> _markSent(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function(Future<void> Function(), String) guardSnack,
  ) async {
    final inv = data.invoice;
    final closesOut =
        ref.read(closesOutContractProvider(inv.id)).asData?.value ?? false;

    if (closesOut) {
      final statement =
          ref.read(finalInvoiceStatementProvider(finalInvoiceParamsFor(inv)));
      final contractTotal =
          statement.asData?.value?.contractTotalCents ?? inv.totalAmount;
      final choice = await showCloseOutContractDialog(
        context,
        contractTotalCents: contractTotal,
        currentTypeLabel: invoiceTypeLabel(inv.invoiceType),
      );
      if (choice == null || !context.mounted) return; // cancelled — send nothing

      if (choice == CloseOutChoice.markFinalAndSend) {
        await ref.read(invoiceEditActionsProvider.notifier).updateInvoiceMetadata(
              original: inv,
              invoiceType: 'final',
              poNumber: inv.poNumber,
              workDescription: inv.workDescription,
              notes: inv.notes,
              internalNotes: inv.internalNotes,
              date: DateTime.tryParse(inv.invoiceDate) ?? DateTime.now(),
            );
        if (!context.mounted) return;
        final e = ref.read(invoiceEditActionsProvider);
        if (e.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Could not retype the invoice: ${e.error}'),
            backgroundColor: Colors.red,
          ));
          return;
        }
      }
    }

    await guardSnack(
      () => ref.read(invoiceActionsProvider.notifier).markSent(inv),
      'Marked as sent.',
    );
  }

  Future<void> _sharePdf(
      BuildContext context, FinalInvoiceStatement? statement) async {
    try {
      final bytes = await InvoicePdfService.build(data, statement: statement);
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'Invoice_${data.invoice.invoiceNumber}.pdf',
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not share PDF: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inv = data.invoice;
    final fullyPaid = data.status == InvoiceStatus.paid;
    final locked = fullyPaid || inv.isDeleted != 0;
    // Single source for what may still be edited — the same rule the write
    // actions enforce, so the button can't offer something the action refuses.
    final scope = invoiceEditScopeFor(inv, data.paidCents);
    final busy = ref.watch(invoiceActionsProvider).isLoading ||
        ref.watch(invoiceEditActionsProvider).isLoading;
    // Same statement the document renders, so the PDF matches what's on screen.
    final statement = inv.invoiceType == 'final'
        ? ref
            .watch(finalInvoiceStatementProvider(finalInvoiceParamsFor(inv)))
            .asData
            ?.value
        : null;

    Future<void> guardSnack(Future<void> Function() op, String okMsg) async {
      await op();
      final s = ref.read(invoiceActionsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(s.hasError ? 'Failed: ${s.error}' : okMsg),
        backgroundColor: s.hasError ? Colors.red : Colors.green,
      ));
    }

    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          // Cap the bar height so a multi-row Wrap on narrow tablets scrolls
          // instead of pushing the buttons off-screen.
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.4,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
            // PDF export is available for any status — voided invoices are
            // watermarked, not refused.
            FilledButton.tonalIcon(
              onPressed: () => _printPdf(context, statement),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Print / Preview'),
            ),
            OutlinedButton.icon(
              onPressed: () => _sharePdf(context, statement),
              icon: const Icon(Icons.share),
              label: const Text('Share PDF'),
            ),
            // Editable unless voided. Paid in full narrows the edit to
            // metadata — type, date, notes — with every amount frozen; the
            // button says which it is so the scope is clear before tapping.
            if (scope != InvoiceEditScope.none)
              FilledButton.tonalIcon(
                onPressed: () => _editInvoice(context, scope),
                icon: Icon(scope == InvoiceEditScope.metadataOnly
                    ? Icons.edit_note
                    : Icons.edit),
                label: Text(scope == InvoiceEditScope.metadataOnly
                    ? 'Edit Details'
                    : 'Edit'),
              ),
            if (inv.isSent == 0 && !locked)
              FilledButton.tonalIcon(
                onPressed: busy ? null : () => _markSent(context, ref, guardSnack),
                icon: const Icon(Icons.send),
                label: const Text('Mark Sent'),
              ),
            // Mark Paid only once the invoice is at least Sent — you can't have
            // been paid for something never sent. `partial` implies past-sent.
            if (data.status == InvoiceStatus.sent ||
                data.status == InvoiceStatus.partial)
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: Colors.green),
                onPressed: busy
                    ? null
                    : () async {
                        final p = await showRecordPaymentDialog(context,
                            total: data.balanceDue);
                        if (p == null || !context.mounted) return;
                        await guardSnack(
                          () => ref.read(invoiceActionsProvider.notifier).recordPayment(
                                inv,
                                amount: p.amount,
                                method: p.method,
                                reference: p.reference,
                                date: p.date,
                                notes: p.notes,
                              ),
                          'Payment recorded.',
                        );
                      },
                icon: const Icon(Icons.payments),
                label: const Text('Mark Paid'),
              ),
            if (inv.isDeleted == 0 && !fullyPaid)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: busy
                    ? null
                    : () async {
                        final v = await showVoidInvoiceDialog(context);
                        if (v == null || !context.mounted) return;
                        await guardSnack(
                          () => ref.read(invoiceActionsProvider.notifier).softDelete(
                                inv,
                                reasonCode: v.reasonCode,
                                notes: v.notes,
                              ),
                          'Invoice voided.',
                        );
                      },
                icon: const Icon(Icons.block),
                label: const Text('Void'),
              ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Read-only notice that a T&M invoice's stored amounts no longer match what the
/// same lines would bill at today — a rate or markup moved after it was issued.
///
/// Purely informational: the snapshot policy stands, so nothing here reprices
/// anything. It exists because that drift was previously detected and then
/// hidden — `_submitEdit` only consults `hasDrift` when the line SELECTION
/// changed, so a rate-only change left the invoice silently stale. Recalculating
/// is an explicit action on the edit screen.
///
/// Renders nothing at all when there is no drift, while the model is loading, or
/// for a non-T&M invoice (the caller gates on `invoiceType == 'extras'`).
class _DriftNotice extends ConsumerWidget {
  const _DriftNotice({required this.invoice});
  final DbInvoice invoice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref
        .watch(editableTmInvoiceLinesProvider(
            (projectId: invoice.projectId, invoiceId: invoice.id)))
        .asData
        ?.value;
    if (data == null || !data.hasDrift) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final billedRate = data.billedLabourRateCents;
    final currentRate = data.currentLabourRateCents;

    String rateLine() {
      if (billedRate == null) return '';
      final now = currentRate == null
          ? 'rates now vary by employee'
          : 'now ${_currency.format(currentRate / 100)}/hr';
      return 'Labour billed at about '
          '${_currency.format(billedRate / 100)}/hr — $now.';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 18,
                    color: scheme.onSecondaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Billed at earlier rates',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: scheme.onSecondaryContainer),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (data.driftLabour && billedRate != null)
              Text(rateLine(),
                  style: TextStyle(color: scheme.onSecondaryContainer)),
            if (data.driftLabour)
              Text(
                'Labour: ${_currency.format(invoice.labourSubtotal / 100)} '
                'billed → ${_currency.format(data.liveBilledLabourCents / 100)} '
                'at current rates.',
                style: TextStyle(color: scheme.onSecondaryContainer),
              ),
            if (data.driftMaterials)
              Text(
                'Materials: '
                '${_currency.format(invoice.materialsSubtotal / 100)} billed → '
                '${_currency.format(data.liveBilledMaterialsCents / 100)} at '
                'current markup.',
                style: TextStyle(color: scheme.onSecondaryContainer),
              ),
            const SizedBox(height: 6),
            Text(
              'This invoice keeps the amounts it was issued with. Use '
              'Recalculate at current rates on the edit screen to move it onto '
              'the new figures.',
              style: TextStyle(
                  fontSize: 12, color: scheme.onSecondaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      InvoiceStatus.voided => ('Void', Colors.red),
      InvoiceStatus.paid => ('Paid', Colors.green),
      InvoiceStatus.partial => ('Partial', Colors.orange),
      InvoiceStatus.sent => ('Sent', Colors.blue),
      InvoiceStatus.draft => ('Draft', Colors.orange),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(127)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
