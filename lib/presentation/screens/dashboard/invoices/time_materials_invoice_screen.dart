import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/invoice_calc.dart';
import '../../../providers/invoice_edit_providers.dart';
import '../../../providers/invoice_providers.dart';
import '../../../widgets/async_value_view.dart';
import '../invoice_detail_screen.dart';

/// Outcome of the drift reconciliation prompt.
enum _ReconChoice { rebill, cancel }

final _currency = NumberFormat.currency(symbol: '\$');

/// Drops a trailing `.0` so a 5% rate seeds as "5", not "5.0".
String _fmtRate(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

/// Create a Time & Materials invoice (`'extras'`) for a project: pick unbilled
/// time entries + materials, apply discount/tax, create transactionally (which
/// also marks the picked records billed). Form *state* lives in
/// [timeMaterialsInvoiceFormProvider]; this widget owns only the controllers.
class TimeMaterialsInvoiceScreen extends ConsumerStatefulWidget {
  const TimeMaterialsInvoiceScreen({
    super.key,
    required this.projectId,
    this.editingInvoiceId,
  });

  final int projectId;

  /// When non-null, edit this existing `'extras'` invoice in place instead of
  /// creating a new one.
  final int? editingInvoiceId;

  @override
  ConsumerState<TimeMaterialsInvoiceScreen> createState() =>
      _TimeMaterialsInvoiceScreenState();
}

class _TimeMaterialsInvoiceScreenState
    extends ConsumerState<TimeMaterialsInvoiceScreen> {
  bool get _isEdit => widget.editingInvoiceId != null;
  bool _seededEdit = false;
  final _po = TextEditingController();
  final _description = TextEditingController();
  final _notes = TextEditingController();
  final _internalNotes = TextEditingController();
  final _discountAmount = TextEditingController();
  final _discountPercent = TextEditingController();
  final _discountDescription = TextEditingController();
  final _tax1Name = TextEditingController(text: 'GST');
  final _tax1Rate = TextEditingController();
  final _tax2Name = TextEditingController();
  final _tax2Rate = TextEditingController();

  @override
  void dispose() {
    _po.dispose();
    _description.dispose();
    _notes.dispose();
    _internalNotes.dispose();
    _discountAmount.dispose();
    _discountPercent.dispose();
    _discountDescription.dispose();
    _tax1Name.dispose();
    _tax1Rate.dispose();
    _tax2Name.dispose();
    _tax2Rate.dispose();
    super.dispose();
  }

  TimeMaterialsInvoiceForm get _form =>
      ref.read(timeMaterialsInvoiceFormProvider.notifier);

  @override
  Widget build(BuildContext context) {
    return _isEdit ? _buildEdit(context) : _buildCreate(context);
  }

  Widget _buildCreate(BuildContext context) {
    final linesA = ref.watch(tmInvoiceLinesProvider(widget.projectId));
    final state = ref.watch(timeMaterialsInvoiceFormProvider);
    final company =
        ref.watch(companySettingsStreamProvider).maybeWhen(data: (v) => v, orElse: () => null);
    final nextNumber =
        ref.watch(nextInvoiceNumberProvider).maybeWhen(data: (v) => v, orElse: () => null);
    final busy = ref.watch(invoiceCreateActionsProvider).isLoading;

    if (company != null && !state.seeded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _form.seedFromCompany(company);
        final s = ref.read(timeMaterialsInvoiceFormProvider);
        _tax1Name.text = s.tax1Name;
        _tax1Rate.text = _fmtRate(s.tax1Rate);
        if (s.tax2Enabled) {
          _tax2Name.text = s.tax2Name;
          _tax2Rate.text = _fmtRate(s.tax2Rate);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('New Time & Materials Invoice')),
      body: AsyncValueView<TmInvoiceLines?>(
        value: linesA,
        builder: (lines) {
          if (lines == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Project not found.', textAlign: TextAlign.center),
              ),
            );
          }
          return _buildForm(context, lines, state, nextNumber, busy);
        },
      ),
    );
  }

  Widget _buildEdit(BuildContext context) {
    final editA = ref.watch(editableTmInvoiceLinesProvider(
        (projectId: widget.projectId, invoiceId: widget.editingInvoiceId!)));
    final state = ref.watch(timeMaterialsInvoiceFormProvider);
    final busy = ref.watch(invoiceEditActionsProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Time & Materials Invoice')),
      body: AsyncValueView<EditableTmInvoiceData?>(
        value: editA,
        builder: (data) {
          if (data == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Invoice not found.', textAlign: TextAlign.center),
              ),
            );
          }
          _maybeSeedEdit(data);
          return _buildForm(
            context,
            data.lines,
            state,
            data.invoice.invoiceNumber,
            busy,
            editData: data,
          );
        },
      ),
    );
  }

  /// One-time seed of the form + controllers from the invoice being edited, and
  /// pre-selection of the lines already billed to it.
  void _maybeSeedEdit(EditableTmInvoiceData data) {
    if (_seededEdit) return;
    _seededEdit = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final inv = data.invoice;
      _form.setAllTime(data.billedTimeIds, true);
      _form.setAllMaterials(data.billedMaterialIds, true);
      _form.setDate(DateTime.tryParse(inv.invoiceDate) ?? DateTime.now());
      _form.setPoNumber(inv.poNumber ?? '');
      _form.setWorkDescription(inv.workDescription ?? '');
      _form.setNotes(inv.notes ?? '');
      _form.setInternalNotes(inv.internalNotes ?? '');

      // discountAmount is stored as the combined (flat + percent) value; split
      // the flat component back out so re-applying the percent doesn't double it.
      final percentPortion =
          (inv.subtotal * inv.discountPercent / 100).round();
      final flatCents =
          (inv.discountAmount - percentPortion).clamp(0, inv.discountAmount);
      _form.setDiscountAmountText(
          flatCents > 0 ? (flatCents / 100).toStringAsFixed(2) : '');
      _form.setDiscountPercentText(
          inv.discountPercent > 0 ? _fmtRate(inv.discountPercent) : '');
      _form.setDiscountDescription(inv.discountDescription ?? '');

      _form.setTax1Name(inv.tax1Name ?? 'GST');
      _form.setTax1Rate((inv.tax1Rate ?? 0).toString());
      final hasTax2 = inv.tax2Rate != null;
      _form.toggleTax2(hasTax2);
      if (hasTax2) {
        _form.setTax2Name(inv.tax2Name ?? '');
        _form.setTax2Rate(inv.tax2Rate!.toString());
      }

      // Sync controllers to the seeded values.
      _po.text = inv.poNumber ?? '';
      _description.text = inv.workDescription ?? '';
      _notes.text = inv.notes ?? '';
      _internalNotes.text = inv.internalNotes ?? '';
      _discountAmount.text =
          flatCents > 0 ? (flatCents / 100).toStringAsFixed(2) : '';
      _discountPercent.text =
          inv.discountPercent > 0 ? _fmtRate(inv.discountPercent) : '';
      _discountDescription.text = inv.discountDescription ?? '';
      _tax1Name.text = inv.tax1Name ?? 'GST';
      _tax1Rate.text = _fmtRate(inv.tax1Rate ?? 0);
      if (hasTax2) {
        _tax2Name.text = inv.tax2Name ?? '';
        _tax2Rate.text = _fmtRate(inv.tax2Rate!);
      }
    });
  }

  Widget _buildForm(
    BuildContext context,
    TmInvoiceLines lines,
    TmInvoiceFormState state,
    String? nextNumber,
    bool busy, {
    EditableTmInvoiceData? editData,
  }) {
    final liveLabour = lines.timeLines
        .where((l) => state.selectedTimeIds.contains(l.id))
        .fold(0, (s, l) => s + l.valueCents);
    final liveMaterials = lines.materialLines
        .where((l) => state.selectedMaterialIds.contains(l.id))
        .fold(0, (s, l) => s + l.billableCents);

    // In edit mode, if the line selection is unchanged from what was billed we
    // keep the stored aggregates (untouched lines never reflow) — so the totals
    // card must show those, matching what a save will persist. Any line change
    // re-sums at live rates (gated on drift at save).
    final labourCents =
        (editData != null && !_lineChanged(lines, state, editData))
            ? editData.invoice.labourSubtotal
            : liveLabour;
    final materialsCents =
        (editData != null && !_lineChanged(lines, state, editData))
            ? editData.invoice.materialsSubtotal
            : liveMaterials;
    final subtotal = labourCents + materialsCents;
    final discountCents = _form.discountCentsFor(subtotal);
    final totals = _form.totalsFor(labourCents, materialsCents);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _header(context, lines, nextNumber, state.date),
              // Rate-only drift: same lines, different value. `_submitEdit`
              // can't see this case (it gates the drift dialog on a selection
              // change), so it gets its own notice + explicit action.
              if (editData != null &&
                  editData.hasDrift &&
                  !_lineChanged(lines, state, editData)) ...[
                const SizedBox(height: 12),
                _driftCard(context, editData),
              ],
              if (lines.project.pricingModel == 'fixed') ...[
                const SizedBox(height: 12),
                _fixedPriceNote(context),
              ],
              const SizedBox(height: 12),
              if (lines.isEmpty)
                _card([
                  const Text(
                      'No unbilled time or materials for this project.'),
                ])
              else ...[
                _timeSection(lines, state),
                const SizedBox(height: 12),
                _materialsSection(lines, state),
              ],
              const SizedBox(height: 12),
              // A PO number is a client-supplied code, reproduced exactly as
              // they issued it — arbitrary mixed case, so no capitalization
              // styling. (`characters` would lock the keyboard into caps and
              // make a lowercase character untypeable.) See the note on Work
              // Performed below for why both keyboard flags are needed.
              TextField(
                controller: _po,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec('PO Number (optional)'),
                onChanged: _form.setPoNumber,
              ),
              const SizedBox(height: 12),
              // `autocorrect` and `enableSuggestions` must BOTH be off, and on
              // Android they are independent settings: with only autocorrect
              // off, Gboard still offered a highlighted candidate and committed
              // it on the spacebar — silently turning "helo" into "help" in text
              // that gets printed for a client. Don't drop either one.
              TextField(
                controller: _description,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec('Work Performed (optional)'),
                onChanged: _form.setWorkDescription,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notes,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec(
                  'Notes (printed on invoice)',
                  helper: 'Printed whenever filled in.',
                ),
                onChanged: _form.setNotes,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _internalNotes,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec(
                  'Internal Notes (optional)',
                  helper: 'Never printed on the invoice.',
                ),
                onChanged: _form.setInternalNotes,
              ),
              const SizedBox(height: 12),
              _discountSection(),
              const SizedBox(height: 16),
              _taxSection(state),
              const SizedBox(height: 16),
              _totalsCard(labourCents, materialsCents, subtotal, discountCents,
                  totals, state, lines.markupPercent,
                  _labourRateLabel(lines, state)),
            ],
          ),
        ),
        _footer(
          canSubmit: state.isValid && !busy,
          busy: busy,
          isEdit: _isEdit,
          onSubmit: () => editData != null
              ? _submitEdit(context, editData)
              : _submit(context, lines),
        ),
      ],
    );
  }

  Future<void> _submit(BuildContext context, TmInvoiceLines lines) async {
    // Compute billed IDs and subtotals from one fresh state snapshot so the
    // companion's labour/materials totals match exactly the records billed.
    final state = ref.read(timeMaterialsInvoiceFormProvider);
    final selTime = lines.timeLines
        .where((l) => state.selectedTimeIds.contains(l.id))
        .toList();
    final selMat = lines.materialLines
        .where((l) => state.selectedMaterialIds.contains(l.id))
        .toList();
    final labourCents = selTime.fold(0, (s, l) => s + l.valueCents);
    final materialsCents = selMat.fold(0, (s, l) => s + l.billableCents);
    final timeIds = selTime.map((l) => l.id).toList();
    final materialIds = selMat.map((l) => l.id).toList();

    final id = await ref.read(invoiceCreateActionsProvider.notifier).createInvoice(
          _form.buildCompanion(lines.project,
              labourCents: labourCents, materialsCents: materialsCents),
          timeIds: timeIds,
          materialIds: materialIds,
        );
    if (!context.mounted) return;
    final s = ref.read(invoiceCreateActionsProvider);
    if (s.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create invoice: ${s.error}'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (id != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invoice created.'),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => InvoiceDetailScreen(invoiceId: id),
      ));
    }
  }

  /// Whether the current line selection differs from what was originally billed
  /// to the invoice. Drives snapshot vs re-sum: no change → keep stored
  /// aggregates (untouched lines never reflow); changed → re-sum at live rates,
  /// gated on drift.
  bool _lineChanged(
      TmInvoiceLines lines, TmInvoiceFormState state, EditableTmInvoiceData data) {
    final selTime = lines.timeLines
        .where((l) => state.selectedTimeIds.contains(l.id))
        .map((l) => l.id)
        .toSet();
    final selMat = lines.materialLines
        .where((l) => state.selectedMaterialIds.contains(l.id))
        .map((l) => l.id)
        .toSet();
    return !setEquals(selTime, data.billedTimeIds) ||
        !setEquals(selMat, data.billedMaterialIds);
  }

  Future<void> _submitEdit(
      BuildContext context, EditableTmInvoiceData data) async {
    final state = ref.read(timeMaterialsInvoiceFormProvider);
    final selTime = data.lines.timeLines
        .where((l) => state.selectedTimeIds.contains(l.id))
        .toList();
    final selMat = data.lines.materialLines
        .where((l) => state.selectedMaterialIds.contains(l.id))
        .toList();
    final timeIds = selTime.map((l) => l.id).toSet();
    final materialIds = selMat.map((l) => l.id).toSet();

    final lineChanged = _lineChanged(data.lines, state, data);

    int labourCents;
    int materialsCents;
    if (!lineChanged) {
      labourCents = data.invoice.labourSubtotal;
      materialsCents = data.invoice.materialsSubtotal;
    } else {
      if (data.hasDrift) {
        final choice = await _showReconciliationDialog(context, data);
        if (!context.mounted) return;
        if (choice != _ReconChoice.rebill) {
          // "Cancel & fix the record" — back out cleanly to invoice detail with
          // nothing written, so the source record can be corrected first.
          Navigator.of(context).pop();
          return;
        }
      }
      labourCents = selTime.fold(0, (s, l) => s + l.valueCents);
      materialsCents = selMat.fold(0, (s, l) => s + l.billableCents);
    }

    await ref.read(invoiceEditActionsProvider.notifier).updateTmInvoice(
          original: data.invoice,
          labourCents: labourCents,
          materialsCents: materialsCents,
          timeIds: timeIds.toList(),
          materialIds: materialIds.toList(),
          discountAmountCents: state.discountAmountCents,
          discountPercent: state.discountPercent,
          discountDescription: state.discountDescription.trim().isEmpty
              ? null
              : state.discountDescription.trim(),
          tax1Name: state.tax1Name,
          tax1Rate: state.tax1Rate,
          tax2Enabled: state.tax2Enabled,
          tax2Name: state.tax2Name,
          tax2Rate: state.tax2Rate,
          poNumber:
              state.poNumber.trim().isEmpty ? null : state.poNumber.trim(),
          workDescription: state.workDescription.trim().isEmpty
              ? null
              : state.workDescription.trim(),
          notes: state.notes.trim().isEmpty ? null : state.notes.trim(),
          internalNotes: state.internalNotes.trim().isEmpty
              ? null
              : state.internalNotes.trim(),
          date: state.date,
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
      content: Text('Invoice updated.'),
      backgroundColor: Colors.green,
    ));
    Navigator.of(context).pop(); // back to detail; streams refresh it
  }

  /// Rate/markup drift with the line selection UNCHANGED — reported read-only,
  /// plus the one explicit action that moves the invoice onto current rates.
  ///
  /// The snapshot policy is untouched: this never reprices on its own. Sending
  /// state decides the friction, per the agreed rule — an unsent invoice
  /// recalculates directly, a sent one has to clear the existing reconciliation
  /// dialog first, because that document is already in the client's hands.
  Widget _driftCard(BuildContext context, EditableTmInvoiceData data) {
    final scheme = Theme.of(context).colorScheme;
    final billedRate = data.billedLabourRateCents;
    final currentRate = data.currentLabourRateCents;
    final sent = data.invoice.isSent != 0;

    Widget line(String text, {bool small = false}) => Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(text,
              style: TextStyle(
                  fontSize: small ? 12 : null,
                  color: scheme.onSecondaryContainer)),
        );

    return Card(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline,
                    size: 18, color: scheme.onSecondaryContainer),
                const SizedBox(width: 8),
                Text('Billed at earlier rates',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: scheme.onSecondaryContainer)),
              ],
            ),
            const SizedBox(height: 6),
            if (data.driftLabour && billedRate != null)
              line('Labour billed at about '
                  '${_currency.format(billedRate / 100)}/hr — '
                  '${currentRate == null ? 'rates now vary by employee' : 'now ${_currency.format(currentRate / 100)}/hr'}.'),
            if (data.driftLabour)
              line('Labour: ${_currency.format(data.invoice.labourSubtotal / 100)}'
                  ' billed → '
                  '${_currency.format(data.liveBilledLabourCents / 100)} at '
                  'current rates.'),
            if (data.driftMaterials)
              line('Materials: '
                  '${_currency.format(data.invoice.materialsSubtotal / 100)}'
                  ' billed → '
                  '${_currency.format(data.liveBilledMaterialsCents / 100)} at '
                  'current markup.'),
            const SizedBox(height: 6),
            line(
              sent
                  ? 'This invoice has been sent, so recalculating asks you to '
                      'confirm the change first.'
                  : 'Saving other changes leaves these amounts as they are.',
              small: true,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonalIcon(
                onPressed: () => _submitRecalculate(context, data),
                icon: const Icon(Icons.refresh),
                label: const Text('Recalculate at current rates'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Writes the live recompute of the CURRENTLY BILLED lines over the invoice's
  /// stored amounts. Deliberately uses [EditableTmInvoiceData.liveBilledLabourCents]
  /// — the very figures the drift check and the card above report — so what the
  /// user was shown is exactly what gets saved.
  ///
  /// Line ids come from `billedTimeIds`/`billedMaterialIds`, not the live
  /// selection: the card only appears when those agree, and pinning them keeps a
  /// recalculation from quietly folding in a selection edit as well.
  Future<void> _submitRecalculate(
      BuildContext context, EditableTmInvoiceData data) async {
    if (data.invoice.isSent != 0) {
      final choice = await _showReconciliationDialog(context, data,
          fromRecalculate: true);
      if (!context.mounted) return;
      if (choice != _ReconChoice.rebill) return;
    }

    final state = ref.read(timeMaterialsInvoiceFormProvider);
    await ref.read(invoiceEditActionsProvider.notifier).updateTmInvoice(
          original: data.invoice,
          labourCents: data.liveBilledLabourCents,
          materialsCents: data.liveBilledMaterialsCents,
          timeIds: data.billedTimeIds.toList(),
          materialIds: data.billedMaterialIds.toList(),
          discountAmountCents: state.discountAmountCents,
          discountPercent: state.discountPercent,
          discountDescription: state.discountDescription.trim().isEmpty
              ? null
              : state.discountDescription.trim(),
          tax1Name: state.tax1Name,
          tax1Rate: state.tax1Rate,
          tax2Enabled: state.tax2Enabled,
          tax2Name: state.tax2Name,
          tax2Rate: state.tax2Rate,
          poNumber:
              state.poNumber.trim().isEmpty ? null : state.poNumber.trim(),
          workDescription: state.workDescription.trim().isEmpty
              ? null
              : state.workDescription.trim(),
          notes: state.notes.trim().isEmpty ? null : state.notes.trim(),
          internalNotes: state.internalNotes.trim().isEmpty
              ? null
              : state.internalNotes.trim(),
          date: state.date,
        );
    if (!context.mounted) return;
    final s = ref.read(invoiceEditActionsProvider);
    if (s.hasError) {
      final msg = s.error is InvoiceEditException
          ? (s.error as InvoiceEditException).message
          : 'Failed to recalculate: ${s.error}';
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red));
      return;
    }
    // Stay on the edit screen — the streams refresh, drift clears, and the card
    // disappears on its own, which is the confirmation.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Invoice recalculated at current rates.'),
      backgroundColor: Colors.green,
    ));
  }

  /// [fromRecalculate] distinguishes the two ways in: a line-selection change
  /// that FORCES a recalculation, versus the user deliberately asking for one on
  /// a sent invoice. Same figures either way — only the explanation differs, so
  /// neither path shows the other's reason.
  Future<_ReconChoice?> _showReconciliationDialog(
      BuildContext context, EditableTmInvoiceData data,
      {bool fromRecalculate = false}) {
    Widget reconRow(String label, int billed, int live) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            '$label: billed ${_currency.format(billed / 100)} → '
            'now ${_currency.format(live / 100)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );

    return showDialog<_ReconChoice>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(fromRecalculate
            ? 'Recalculate a sent invoice?'
            : 'Line values have changed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fromRecalculate
                  ? 'This invoice has already been sent to the client at the '
                      'amounts below. Recalculating replaces them with current '
                      'rates:'
                  : 'Since this invoice was billed, a rate or markup behind '
                      'these lines has changed. Changing the line selection '
                      'forces a recalculation, so the difference has to be '
                      'resolved:',
            ),
            const SizedBox(height: 12),
            if (data.driftLabour)
              reconRow('Labour', data.invoice.labourSubtotal,
                  data.liveBilledLabourCents),
            if (data.driftMaterials)
              reconRow('Materials', data.invoice.materialsSubtotal,
                  data.liveBilledMaterialsCents),
            const SizedBox(height: 12),
            Text(
              fromRecalculate
                  ? 'The client already has the old figures, so you may need to '
                      'reissue or explain the change.'
                  : 'Re-bill at current rates to accept the new values, or '
                      'cancel and fix the underlying record first (e.g. split '
                      'the entry across the rate change).',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, _ReconChoice.cancel),
            child: Text(fromRecalculate
                ? 'Keep sent amounts'
                : 'Cancel & fix the record'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, _ReconChoice.rebill),
            child: const Text('Re-bill at current rates'),
          ),
        ],
      ),
    );
  }

  // ---- sections ------------------------------------------------------------

  Widget _header(BuildContext context, TmInvoiceLines lines, String? nextNumber,
      DateTime date) {
    return _card([
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bill To',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(lines.clientName),
                Text(lines.project.projectName),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Invoice #: ${nextNumber ?? '…'}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _pickDate(context, date),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event, size: 16),
                    const SizedBox(width: 4),
                    Text(DateFormat('MMM d, yyyy').format(date)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  /// Non-blocking note shown when invoicing a fixed-price project, explaining
  /// why only Billable-coded entries appear (Contract Work is already covered by
  /// the contract price, so it's excluded to avoid double-billing).
  Widget _fixedPriceNote(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Only Billable-coded entries shown — Contract Work is excluded '
                  '(already covered by the contract price).',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _timeSection(TmInvoiceLines lines, TmInvoiceFormState state) {
    if (lines.timeLines.isEmpty) return const SizedBox.shrink();
    final allSelected =
        lines.timeLines.every((l) => state.selectedTimeIds.contains(l.id));
    return _card([
      _sectionHeader(_isEdit ? 'Time' : 'Unbilled Time', allSelected,
          () => _form.setAllTime(lines.timeLines.map((l) => l.id), !allSelected)),
      for (final l in lines.timeLines)
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          value: state.selectedTimeIds.contains(l.id),
          onChanged: (_) => _form.toggleTime(l.id),
          title: Text(l.label, style: const TextStyle(fontSize: 13)),
          secondary: Text(_currency.format(l.valueCents / 100)),
        ),
    ]);
  }

  /// Materials picker. Line amounts are the **raw purchase cost**, so an item can
  /// be found by the figure on its receipt; the project's markup is applied at
  /// invoicing, not here. The header discloses that gap (and is omitted when the
  /// markup is 0, since then cost is what gets billed).
  Widget _materialsSection(TmInvoiceLines lines, TmInvoiceFormState state) {
    if (lines.materialLines.isEmpty) return const SizedBox.shrink();
    final allSelected = lines.materialLines
        .every((l) => state.selectedMaterialIds.contains(l.id));
    final markup = lines.markupPercent;
    return _card([
      _sectionHeader(
        _isEdit ? 'Materials' : 'Unbilled Materials',
        allSelected,
        () => _form.setAllMaterials(
            lines.materialLines.map((l) => l.id), !allSelected),
        note: markup > 0
            ? 'Shown at cost — ${_fmtRate(markup)}% markup applied at invoicing'
            : null,
      ),
      for (final l in lines.materialLines)
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          value: state.selectedMaterialIds.contains(l.id),
          onChanged: (_) => _form.toggleMaterial(l.id),
          title: Text(l.label, style: const TextStyle(fontSize: 13)),
          secondary: Text(_currency.format(l.costCents / 100)),
        ),
    ]);
  }

  Widget _discountSection() {
    return _card([
      const Text('Discount (optional)',
          style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _discountAmount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _dec('Amount', prefix: '\$ '),
              onChanged: _form.setDiscountAmountText,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _discountPercent,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _dec('Percent %'),
              onChanged: _form.setDiscountPercentText,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _discountDescription,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: false,
        enableSuggestions: false,
        decoration: _dec('Discount description'),
        onChanged: _form.setDiscountDescription,
      ),
    ]);
  }

  Widget _taxSection(TmInvoiceFormState state) {
    return _card([
      const Text('Taxes', style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              // User-labelled tax slot ("GST", "Sales Tax", …), so no caps lock
              // — matches the Company & Tax settings tab it seeds from.
              controller: _tax1Name,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              enableSuggestions: false,
              decoration: _dec('Tax 1 Name'),
              onChanged: _form.setTax1Name,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _tax1Rate,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _dec('Rate %'),
              onChanged: _form.setTax1Rate,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Checkbox(
            value: state.tax2Enabled,
            onChanged: (v) => _form.toggleTax2(v ?? false),
          ),
          const Text('Second tax'),
        ],
      ),
      if (state.tax2Enabled)
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                // User-labelled tax slot — see Tax 1 Name above.
                controller: _tax2Name,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec('Tax 2 Name'),
                onChanged: _form.setTax2Name,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _tax2Rate,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: _dec('Rate %'),
                onChanged: _form.setTax2Rate,
              ),
            ),
          ],
        ),
    ]);
  }

  /// Labour row label for the totals card: `Labour ($74.92/hr)` when every
  /// selected time line resolved to the same rate — the project's own
  /// `billedHourlyRate`, or the company Default Billing Rate when it has none
  /// (the chain lives in `hourlyRateCents`).
  ///
  /// A bare `Labour` when nothing is selected, and `Labour (mixed rates)` when
  /// the selection spans more than one rate — a crew of employees on differing
  /// role rates — because quoting any single figure there would be wrong.
  ///
  /// SCREEN-ONLY, exactly like the Materials markup label. `invoice_pdf_service`
  /// prints the Labour total with no rate and must stay that way: clients don't
  /// get an hourly breakdown.
  String _labourRateLabel(TmInvoiceLines lines, TmInvoiceFormState state) {
    final rates = <int>{
      for (final l in lines.timeLines)
        if (state.selectedTimeIds.contains(l.id)) l.rateCents,
    };
    if (rates.isEmpty) return 'Labour';
    if (rates.length > 1) return 'Labour (mixed rates)';
    return 'Labour (${_currency.format(rates.single / 100)}/hr)';
  }

  /// [markupPercent] only labels the Materials row: that figure is marked up
  /// while the picker above shows cost, so the label says so rather than leaving
  /// the two looking like they should add up. Suppressed at 0% — nothing differs.
  ///
  /// [labourRateLabel] annotates the Labour row the same way — see
  /// [_labourRateLabel]. Both are SCREEN-ONLY: the PDF prints the finished
  /// Labour total with no rate, so clients never see an hourly breakdown.
  Widget _totalsCard(int labourCents, int materialsCents, int subtotal,
      int discountCents, InvoiceTotals totals, TmInvoiceFormState state,
      double markupPercent, String labourRateLabel) {
    return _card([
      _row(labourRateLabel, _currency.format(labourCents / 100)),
      _row(markupPercent > 0 ? 'Materials (incl. markup)' : 'Materials',
          _currency.format(materialsCents / 100)),
      _row('Subtotal', _currency.format(subtotal / 100), bold: true),
      if (discountCents > 0)
        _row(state.discountDescription.isEmpty ? 'Discount' : state.discountDescription,
            '-${_currency.format(discountCents / 100)}'),
      _row('${state.tax1Name} (${state.tax1Rate}%)',
          _currency.format(totals.tax1 / 100)),
      if (state.tax2Enabled)
        _row('${state.tax2Name} (${state.tax2Rate}%)',
            _currency.format(totals.tax2 / 100)),
      const Divider(),
      _row('Total', _currency.format(totals.total / 100), bold: true),
    ]);
  }

  Widget _footer({
    required bool canSubmit,
    required bool busy,
    required bool isEdit,
    required VoidCallback onSubmit,
  }) {
    final label = isEdit
        ? (busy ? 'Saving…' : 'Save Changes')
        : (busy ? 'Creating…' : 'Create Invoice');
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: canSubmit ? onSubmit : null,
              icon: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check),
              label: Text(label),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) _form.setDate(picked);
  }

  // ---- shared bits ---------------------------------------------------------

  /// Section title + select-all toggle, with an optional [note] rendered beneath
  /// the title (used to disclose that material amounts are pre-markup).
  static Widget _sectionHeader(
    String title,
    bool allSelected,
    VoidCallback onToggleAll, {
    String? note,
  }) =>
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (note != null)
                  Text(
                    note,
                    style: const TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: onToggleAll,
            child: Text(allSelected ? 'Clear all' : 'Select all'),
          ),
        ],
      );

  static InputDecoration _dec(String label, {String? prefix, String? helper}) =>
      InputDecoration(
        labelText: label,
        prefixText: prefix,
        helperText: helper,
        helperMaxLines: 2,
        isDense: true,
        border: const OutlineInputBorder(),
      );

  static Widget _card(List<Widget> children) => Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ),
      );

  static Widget _row(String label, String value, {bool bold = false}) {
    final style =
        TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
