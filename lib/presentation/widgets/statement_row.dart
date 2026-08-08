import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Shared layout primitives for statement-style figure blocks: label (and
/// optionally its date) on the left, amount right-aligned in a fixed-width
/// column, with a rule spanning just that column above a total.
///
/// Extracted from `FinalInvoiceStatementView`, which still uses them, so the
/// final-invoice contract statement and the client/project statements present
/// one identical money column instead of two that drift apart.

final _currency = NumberFormat.currency(symbol: '\$');

/// Width of the amount column. Identical on every row — including totals — so
/// the figures form one aligned column.
const double kStatementAmountWidth = 112;

/// Applies only to dated rows, so their dates start at a common x instead of
/// trailing labels of differing length. Undated rows let the label run full
/// width.
const double kStatementLabelWidth = 92;

/// Cents → `$1,234.56`, with negatives rendered as a leading minus (`-$1.00`)
/// rather than parenthesised.
String formatStatementAmount(int cents) => cents < 0
    ? '-${_currency.format(-cents / 100)}'
    : _currency.format(cents / 100);

/// One statement row: label (and [date]) grouped left, amount right.
class StatementAmountRow extends StatelessWidget {
  const StatementAmountRow({
    super.key,
    required this.label,
    required this.cents,
    this.date,
    this.bold = false,
    this.emphasis = false,
  });

  final String label;
  final int cents;

  /// Pre-formatted date shown beside the label. Null renders an undated row.
  final String? date;

  final bool bold;

  /// Slightly larger type, for the one figure the row block builds to.
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: emphasis ? 16 : null,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          if (date != null) ...[
            SizedBox(
                width: kStatementLabelWidth, child: Text(label, style: style)),
            Expanded(
              child: Text(
                date!,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ] else
            Expanded(child: Text(label, style: style)),
          SizedBox(
            width: kStatementAmountWidth,
            child: Text(
              formatStatementAmount(cents),
              style: style,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

/// Rule above a total, spanning just the amount column.
class StatementAmountRule extends StatelessWidget {
  const StatementAmountRule({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Spacer(),
            // A plain Container rather than a Divider: this reproduces the rule
            // the final-invoice statement already shipped with, pixel for pixel.
            Container(
              width: kStatementAmountWidth,
              height: 1,
              color: Colors.black45,
            ),
          ],
        ),
      );
}
