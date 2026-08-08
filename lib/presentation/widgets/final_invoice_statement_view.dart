import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/final_invoice_providers.dart';
import 'statement_row.dart';

final _lineDate = DateFormat('MMM d, yyyy');

/// The client-facing closing statement for a fixed-price final invoice: the
/// contract, every draw already billed against it, and the balance this invoice
/// bills. Shared by the create screen and the saved-invoice document so both
/// read identically; the PDF renders the same figures through its own `pw`
/// widgets.
///
/// Read-only — the statement is fully derived from the contract and the prior
/// invoices (see [FinalInvoiceStatement]), with nothing for the user to enter.
///
/// Row layout comes from `statement_row.dart`, shared with the client and
/// project statement screens so all three present one identical money column.
class FinalInvoiceStatementView extends StatelessWidget {
  const FinalInvoiceStatementView({super.key, required this.statement});

  final FinalInvoiceStatement statement;

  @override
  Widget build(BuildContext context) {
    final s = statement;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatementAmountRow(
          label: 'Project Price (excl. ${s.tax1Name})',
          cents: s.contractPriceCents,
        ),
        StatementAmountRow(label: s.tax1Name, cents: s.contractGstCents),
        StatementAmountRow(
          label: 'Contract Total',
          cents: s.contractTotalCents,
          bold: true,
        ),
        const SizedBox(height: 12),
        for (final l in s.priorLines)
          StatementAmountRow(
            label: l.label,
            cents: l.amountCents,
            date: _lineDate.format(l.date),
          ),
        // A contract whose first invoice is the final one has no prior lines;
        // say so rather than showing a bare $0.00 credit.
        if (s.priorLines.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Text('No previous invoices on this contract.',
                style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        StatementAmountRow(
          label: 'Total Paid to Date',
          cents: -s.totalBilledToDateCents,
          bold: true,
        ),
        const StatementAmountRule(),
        StatementAmountRow(
          label: 'Balance Due',
          cents: s.balanceDueCents,
          bold: true,
          emphasis: true,
        ),
      ],
    );
  }
}
