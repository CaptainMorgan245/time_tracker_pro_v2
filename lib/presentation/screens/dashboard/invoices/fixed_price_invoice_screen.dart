import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/invoice_calc.dart';
import '../../../../data/local/drift/app_database.dart';
import '../../../providers/final_invoice_providers.dart';
import '../../../providers/invoice_edit_providers.dart';
import '../../../providers/invoice_providers.dart';
import '../../../widgets/async_value_view.dart';
import '../../../widgets/final_invoice_statement_view.dart';
import '../invoice_detail_screen.dart';

final _currency = NumberFormat.currency(symbol: '\$');

/// Drops a trailing `.0` so a 5% rate seeds as "5", not "5.0".
String _fmtRate(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

/// Create a fixed-price invoice (deposit / progress draw) against a fixed-price
/// project's contract. All form *state* + validation live in
/// [fixedPriceInvoiceFormProvider]; this widget owns only the
/// [TextEditingController]s and the create is transactional via
/// [invoiceCreateActionsProvider].
class FixedPriceInvoiceScreen extends ConsumerStatefulWidget {
  const FixedPriceInvoiceScreen({
    super.key,
    required this.projectId,
    this.editingInvoiceId,
  });

  final int projectId;

  /// When non-null, edit this existing `'deposit'`/`'progress'` invoice in place
  /// instead of creating a new one.
  final int? editingInvoiceId;

  @override
  ConsumerState<FixedPriceInvoiceScreen> createState() =>
      _FixedPriceInvoiceScreenState();
}

class _FixedPriceInvoiceScreenState
    extends ConsumerState<FixedPriceInvoiceScreen> {
  bool get _isEdit => widget.editingInvoiceId != null;
  bool _seededEdit = false;
  final _amount = TextEditingController();
  final _po = TextEditingController();
  final _description = TextEditingController();
  final _notes = TextEditingController();
  final _internalNotes = TextEditingController();
  final _tax1Name = TextEditingController(text: 'GST');
  final _tax1Rate = TextEditingController();
  final _tax2Name = TextEditingController();
  final _tax2Rate = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _po.dispose();
    _description.dispose();
    _notes.dispose();
    _internalNotes.dispose();
    _tax1Name.dispose();
    _tax1Rate.dispose();
    _tax2Name.dispose();
    _tax2Rate.dispose();
    super.dispose();
  }

  FixedPriceInvoiceForm get _form =>
      ref.read(fixedPriceInvoiceFormProvider.notifier);

  @override
  Widget build(BuildContext context) {
    return _isEdit ? _buildEdit(context) : _buildCreate(context);
  }

  Widget _buildCreate(BuildContext context) {
    final summaryA = ref.watch(fixedPriceSummaryProvider(widget.projectId));
    final state = ref.watch(fixedPriceInvoiceFormProvider);
    final company = ref
        .watch(companySettingsStreamProvider)
        .maybeWhen(data: (v) => v, orElse: () => null);
    final nextNumber = ref
        .watch(nextInvoiceNumberProvider)
        .maybeWhen(data: (v) => v, orElse: () => null);
    final busy = ref.watch(invoiceCreateActionsProvider).isLoading;

    // One-time tax prefill from company defaults. Seeding the notifier is state
    // logic; syncing the controllers to the seeded values is the widget's job.
    // Scheduled post-frame so we don't mutate provider state during build.
    if (company != null && !state.seeded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _form.seedFromCompany(company);
        final s = ref.read(fixedPriceInvoiceFormProvider);
        _tax1Name.text = s.tax1Name;
        _tax1Rate.text = _fmtRate(s.tax1Rate);
        if (s.tax2Enabled) {
          _tax2Name.text = s.tax2Name;
          _tax2Rate.text = _fmtRate(s.tax2Rate);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('New Fixed Price Invoice')),
      body: AsyncValueView<FixedPriceSummary?>(
        value: summaryA,
        builder: (summary) {
          if (summary == null) return _notFixedPrice();
          return _buildForm(context, summary, state, nextNumber, busy);
        },
      ),
    );
  }

  Widget _buildEdit(BuildContext context) {
    final summaryA = ref.watch(fixedPriceSummaryProvider(widget.projectId));
    final detailA = ref.watch(invoiceDetailProvider(widget.editingInvoiceId!));
    final state = ref.watch(fixedPriceInvoiceFormProvider);
    final busy = ref.watch(invoiceEditActionsProvider).isLoading;
    final invoice = detailA.asData?.value?.invoice;
    if (invoice != null) _maybeSeedEdit(invoice);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Fixed Price Invoice')),
      body: AsyncValueView<FixedPriceSummary?>(
        value: summaryA,
        builder: (summary) {
          if (summary == null) return _notFixedPrice();
          if (invoice == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildForm(context, summary, state, invoice.invoiceNumber, busy,
              editInvoice: invoice);
        },
      ),
    );
  }

  /// One-time seed of the form + controllers from the invoice being edited.
  void _maybeSeedEdit(DbInvoice inv) {
    if (_seededEdit) return;
    _seededEdit = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _form.setType(inv.invoiceType);
      _form.setAmountText((inv.subtotal / 100).toStringAsFixed(2));
      _form.setPoNumber(inv.poNumber ?? '');
      _form.setWorkDescription(inv.workDescription ?? '');
      _form.setNotes(inv.notes ?? '');
      _form.setInternalNotes(inv.internalNotes ?? '');
      _form.setTax1Name(inv.tax1Name ?? 'GST');
      _form.setTax1Rate((inv.tax1Rate ?? 0).toString());
      final hasTax2 = inv.tax2Rate != null;
      _form.toggleTax2(hasTax2);
      if (hasTax2) {
        _form.setTax2Name(inv.tax2Name ?? '');
        _form.setTax2Rate(inv.tax2Rate!.toString());
      }

      _amount.text = (inv.subtotal / 100).toStringAsFixed(2);
      _po.text = inv.poNumber ?? '';
      _description.text = inv.workDescription ?? '';
      _notes.text = inv.notes ?? '';
      _internalNotes.text = inv.internalNotes ?? '';
      _tax1Name.text = inv.tax1Name ?? 'GST';
      _tax1Rate.text = _fmtRate(inv.tax1Rate ?? 0);
      if (hasTax2) {
        _tax2Name.text = inv.tax2Name ?? '';
        _tax2Rate.text = _fmtRate(inv.tax2Rate!);
      }
    });
  }

  Widget _notFixedPrice() => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'This project is not a priced fixed-price project, so it '
            "can't be invoiced this way.",
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget _buildForm(
    BuildContext context,
    FixedPriceSummary summary,
    FixedPriceFormState state,
    String? nextNumber,
    bool busy, {
    DbInvoice? editInvoice,
  }) {
    final totals = state.totals;
    // `balanceRemainingCents` already nets out this invoice's current subtotal
    // (it's one of the project's billed draws), so when editing we add it back
    // to compare the new amount against the balance *excluding* this invoice.
    final remainingForCheck = editInvoice != null
        ? summary.balanceRemainingCents + editInvoice.subtotal
        : summary.balanceRemainingCents;
    final overContract = state.amountCents > remainingForCheck;

    // A final invoice takes no amount input: it reconciles the contract against
    // everything already drawn (statement card below replaces the amount field
    // and the totals card). Exclude the invoice being edited from "previously
    // billed" so it never reconciles against itself.
    final isFinal = state.invoiceType == 'final';
    final statement = isFinal
        ? ref
            .watch(finalInvoiceStatementProvider((
              projectId: widget.projectId,
              tax1Rate: state.tax1Rate,
              tax1Name: state.tax1Name,
              excludeInvoiceId: editInvoice?.id,
            )))
            .asData
            ?.value
        : null;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _header(context, summary, nextNumber, state.date),
              const SizedBox(height: 12),
              // The statement states the contract position in full, so the
              // summary card would just repeat it.
              if (!isFinal) ...[
                _contractSummary(summary),
                const SizedBox(height: 12),
              ],
              _typeSelector(state.invoiceType),
              const SizedBox(height: 12),
              if (isFinal)
                _statementCard(statement)
              else ...[
                TextField(
                  controller: _amount,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: _dec('Draw Amount', prefix: '\$ '),
                  onChanged: _form.setAmountText,
                ),
                if (overContract) ...[
                  const SizedBox(height: 8),
                  _warningBanner(
                    'Amount exceeds the remaining contract balance '
                    '(${_currency.format(remainingForCheck / 100)}). '
                    'This will over-bill the contract.',
                  ),
                ],
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
                // Labelled to match the "Work Performed" heading the detail
                // screen and PDF print for this same field.
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
              const SizedBox(height: 16),
              _taxSection(state, isFinal: isFinal),
              if (!isFinal) ...[
                const SizedBox(height: 16),
                _totalsCard(totals, state),
              ],
            ],
          ),
        ),
        _footer(
          canSubmit: (isFinal
                  ? statement != null && !statement.isSettled
                  : state.isValid) &&
              !busy,
          busy: busy,
          isEdit: _isEdit,
          isFinal: isFinal,
          onSubmit: () {
            if (isFinal) {
              if (statement == null) return;
              if (editInvoice != null) {
                _submitFinalEdit(context, editInvoice, statement);
              } else {
                _submitFinal(context, statement);
              }
            } else if (editInvoice != null) {
              _submitEdit(context, editInvoice);
            } else {
              _submit(context, summary);
            }
          },
        ),
      ],
    );
  }

  /// Creates the reconciled final invoice. The amount is entirely derived, so
  /// there is nothing to validate beyond "something is still owed".
  Future<void> _submitFinal(
      BuildContext context, FinalInvoiceStatement statement) async {
    final state = ref.read(fixedPriceInvoiceFormProvider);
    final id =
        await ref.read(invoiceCreateActionsProvider.notifier).createInvoice(
              buildFinalInvoiceCompanion(
                statement,
                date: state.date,
                poNumber: state.poNumber.trim(),
                workDescription: state.workDescription.trim(),
                notes: state.notes.trim(),
                internalNotes: state.internalNotes.trim(),
              ),
            );
    if (!context.mounted) return;
    final s = ref.read(invoiceCreateActionsProvider);
    if (s.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create final invoice: ${s.error}'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (id != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Final invoice created.'),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => InvoiceDetailScreen(invoiceId: id),
      ));
    }
  }

  /// Re-saves an existing final invoice at its freshly reconciled figures,
  /// passing the reconciled GST through rather than letting it be recomputed
  /// from the rate.
  Future<void> _submitFinalEdit(BuildContext context, DbInvoice original,
      FinalInvoiceStatement statement) async {
    final state = ref.read(fixedPriceInvoiceFormProvider);
    await ref.read(invoiceEditActionsProvider.notifier).updateFixedPriceInvoice(
          original: original,
          invoiceType: 'final',
          amountCents: statement.subtotalCents,
          tax1Name: statement.tax1Name,
          tax1Rate: statement.tax1Rate,
          tax2Enabled: false,
          tax2Name: '',
          tax2Rate: 0,
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
          tax1AmountCents: statement.gstCents,
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
      content: Text('Final invoice updated.'),
      backgroundColor: Colors.green,
    ));
    Navigator.of(context).pop();
  }

  Future<void> _submitEdit(BuildContext context, DbInvoice original) async {
    final state = ref.read(fixedPriceInvoiceFormProvider);
    await ref.read(invoiceEditActionsProvider.notifier).updateFixedPriceInvoice(
          original: original,
          invoiceType: state.invoiceType,
          amountCents: state.amountCents,
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

  Future<void> _submit(BuildContext context, FixedPriceSummary summary) async {
    final id = await ref
        .read(invoiceCreateActionsProvider.notifier)
        .createInvoice(_form.buildCompanion(summary.project));
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

  // ---- sections ------------------------------------------------------------

  Widget _header(BuildContext context, FixedPriceSummary summary,
      String? nextNumber, DateTime date) {
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
                Text(summary.clientName),
                Text(summary.project.projectName),
                if ((summary.project.city ?? '').isNotEmpty)
                  Text(summary.project.city!),
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

  Widget _contractSummary(FixedPriceSummary s) {
    return _card([
      const Text('Contract Summary',
          style: TextStyle(fontWeight: FontWeight.bold)),
      _row('Contract Value', _currency.format(s.contractValueCents / 100)),
      _row('Previously Billed', _currency.format(s.billedCents / 100)),
      _row('GST Collected', _currency.format(s.gstCollectedCents / 100)),
      const Divider(),
      _row('Balance Remaining', _currency.format(s.balanceRemainingCents / 100),
          bold: true),
    ]);
  }

  Widget _typeSelector(String type) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('Type: '),
        for (final t in const [
          ['deposit', 'Deposit'],
          ['progress', 'Progress Draw'],
          ['final', 'Final Invoice'],
        ])
          ChoiceChip(
            label: Text(t[1]),
            selected: type == t[0],
            onSelected: (_) => _form.setType(t[0]),
          ),
      ],
    );
  }

  /// The reconciled statement, or why there's nothing to bill. [statement] is
  /// null only while the contract/invoice streams are still resolving.
  Widget _statementCard(FinalInvoiceStatement? statement) {
    if (statement == null) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _card([FinalInvoiceStatementView(statement: statement)]),
        if (statement.isSettled) ...[
          const SizedBox(height: 8),
          _warningBanner(
            statement.isOverDrawn
                ? 'The draws already billed against this contract '
                    '(${_currency.format(statement.totalBilledToDateCents / 100)}) '
                    'exceed the contract total '
                    '(${_currency.format(statement.contractTotalCents / 100)}). '
                    'There is nothing left to bill — correct a draw first.'
                : 'This contract is already fully billed. There is nothing left '
                    'for a final invoice to bill.',
          ),
        ],
      ],
    );
  }

  /// Tax controls. A final invoice reconciles GST against the contract price and
  /// carries no second tax (the contract total it states is GST-only), so the
  /// tax-2 controls are hidden rather than shown and silently ignored.
  Widget _taxSection(FixedPriceFormState state, {required bool isFinal}) {
    return _card([
      Text(isFinal ? '${state.tax1Name} (reconciled)' : 'Taxes',
          style: const TextStyle(fontWeight: FontWeight.bold)),
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
      if (!isFinal)
        Row(
          children: [
            Checkbox(
              value: state.tax2Enabled,
              onChanged: (v) => _form.toggleTax2(v ?? false),
            ),
            const Text('Second tax'),
          ],
        ),
      if (!isFinal && state.tax2Enabled)
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

  Widget _totalsCard(InvoiceTotals totals, FixedPriceFormState state) {
    return _card([
      _row('Subtotal', _currency.format(totals.subtotal / 100)),
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
    required bool isFinal,
    required VoidCallback onSubmit,
  }) {
    final label = isEdit
        ? (busy ? 'Saving…' : 'Save Changes')
        : (busy
            ? 'Creating…'
            : isFinal
                ? 'Create Final Invoice'
                : 'Create Invoice');
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
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }

  static Widget _warningBanner(String text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text, style: const TextStyle(fontSize: 12)),
      );
}
