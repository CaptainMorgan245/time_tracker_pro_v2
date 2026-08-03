import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/final_invoice_providers.dart';

final _currency = NumberFormat.currency(symbol: '\$');
final _lineDate = DateFormat('MMM d, yyyy');

/// The client-facing closing statement for a fixed-price final invoice: the
/// contract, every draw already billed against it, and the balance this invoice
/// bills. Shared by the create screen and the saved-invoice document so both
/// read identically; the PDF renders the same figures through its own `pw`
/// widgets.
///
/// Read-only — the statement is fully derived from the contract and the prior
/// invoices (see [FinalInvoiceStatement]), with nothing for the user to enter.
class FinalInvoiceStatementView extends StatelessWidget {
  const FinalInvoiceStatementView({super.key, required this.statement});

  final FinalInvoiceStatement statement;

  @override
  Widget build(BuildContext context) {
    final s = statement;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Project Price (excl. ${s.tax1Name})', s.contractPriceCents),
        _row(s.tax1Name, s.contractGstCents),
        _row('Contract Total', s.contractTotalCents, bold: true),
        const SizedBox(height: 12),
        for (final l in s.priorLines)
          _row(l.label, l.amountCents, date: _lineDate.format(l.date)),
        // A contract whose first invoice is the final one has no prior lines;
        // say so rather than showing a bare $0.00 credit.
        if (s.priorLines.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Text('No previous invoices on this contract.',
                style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        _row('Total Paid to Date', -s.totalBilledToDateCents, bold: true),
        _amountRule(),
        _row('Balance Due', s.balanceDueCents, bold: true, emphasis: true),
      ],
    );
  }

  /// Two columns: label (+ its date) on the left, amount right-aligned in a
  /// fixed-width column on the right. The amount column is identical on every
  /// row — including Balance Due — so the figures form one aligned column.
  ///
  /// [_labelWidth] applies only to dated rows, so their dates start at a common
  /// x instead of trailing labels of differing length. Undated rows let the
  /// label run the full width.
  static const _labelWidth = 92.0;
  static const _amountWidth = 112.0;

  /// One statement row: label and date grouped left, amount right. Negative
  /// amounts render with a leading minus (the credit line).
  static Widget _row(
    String label,
    int cents, {
    String? date,
    bool bold = false,
    bool emphasis = false,
  }) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: emphasis ? 16 : null,
    );
    final text = cents < 0
        ? '-${_currency.format(-cents / 100)}'
        : _currency.format(cents / 100);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          if (date != null) ...[
            SizedBox(width: _labelWidth, child: Text(label, style: style)),
            Expanded(
              child: Text(date,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.black54)),
            ),
          ] else
            Expanded(child: Text(label, style: style)),
          SizedBox(
            width: _amountWidth,
            child: Text(text, style: style, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  /// Rule above the total, spanning just the amount column.
  static Widget _amountRule() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Spacer(),
            Container(width: _amountWidth, height: 1, color: Colors.black45),
          ],
        ),
      );
}
