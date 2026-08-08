import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/statement_providers.dart';
import 'statement_row.dart';

final _lineDate = DateFormat('MMM d, yyyy');

/// A project's statement ledger: one line per invoice — date, description and
/// invoice number, amount, and payment status — followed by the totals block.
///
/// There are no separate payment-received rows. What was received against an
/// invoice rides on that invoice's own line, so the ledger reads as "here is
/// what you were billed and where each bill stands".
///
/// Shared by the client statement (inside each project's expander) and the
/// project statement screen, so the two can't present the same project
/// differently.
///
/// Four fixed columns, no responsive branch. The app targets tablets (Galaxy
/// Tab S7 / iPad Mini and up), which leave roughly 680dp for the ledger even in
/// the narrowest case — the client statement's expander on an iPad Mini in
/// portrait. There is no supported width at which these columns need to stack.
class StatementLedgerView extends StatelessWidget {
  const StatementLedgerView({
    super.key,
    required this.statement,
    this.windowed = false,
  });

  final ProjectStatement statement;

  /// When true a date filter is narrowing the ledger, so the subtotals are
  /// labelled "in period" — they describe the window, not the project.
  final bool windowed;

  static const double _dateWidth = 92;
  static const double _statusWidth = 96;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _headerRow(),
        if (statement.lines.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              windowed
                  ? 'No invoices in the selected period.'
                  : 'No invoices on this project.',
              style: TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.grey.shade700),
            ),
          )
        else
          for (final line in statement.lines) _WideLine(line: line),
        const SizedBox(height: 4),
        _totals(),
      ],
    );
  }

  Widget _headerRow() {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
    return const Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: _dateWidth, child: Text('Date', style: style)),
          Expanded(child: Text('Description', style: style)),
          SizedBox(
            width: kStatementAmountWidth,
            child: Text('Amount', style: style, textAlign: TextAlign.right),
          ),
          SizedBox(
            width: _statusWidth,
            child: Text('Status', style: style, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  /// Total Billed / Total Paid / Balance Owing.
  ///
  /// Billed and paid are the ledger's own subtotals, so they always foot against
  /// the lines directly above them. Balance Owing is deliberately the LIFETIME
  /// figure and is shown only when the project has reached a final number — an
  /// unfinished project states paid-to-date instead, because its contract amount
  /// can still move.
  Widget _totals() {
    final suffix = windowed ? ' (in period)' : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StatementAmountRule(),
        StatementAmountRow(
          label: 'Total Billed$suffix',
          cents: statement.windowBilledCents,
          bold: true,
        ),
        StatementAmountRow(
          label: 'Total Paid$suffix',
          cents: statement.windowPaidCents,
          bold: true,
        ),
        if (statement.hasFinalBalance) ...[
          const StatementAmountRule(),
          StatementAmountRow(
            label: 'Balance Owing',
            cents: statement.balanceOwingCents,
            bold: true,
            emphasis: true,
          ),
        ],
      ],
    );
  }
}

/// One ledger line: date, description + invoice number, amount, status.
class _WideLine extends StatelessWidget {
  const _WideLine({required this.line});

  final StatementLine line;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: StatementLedgerView._dateWidth,
            child: Text(_lineDate.format(line.date),
                style: const TextStyle(fontSize: 13)),
          ),
          Expanded(child: _Description(line: line)),
          SizedBox(
            width: kStatementAmountWidth,
            child: Text(
              formatStatementAmount(line.amountCents),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          SizedBox(
            width: StatementLedgerView._statusWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: _LineStatusChip(line: line),
            ),
          ),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.line});

  final StatementLine line;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(line.description, style: const TextStyle(fontSize: 13)),
        Text(
          line.invoiceNumber,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

/// PAID / PARTIAL / OUTSTANDING. A partial line carries the amount actually
/// received beneath it — the status alone wouldn't say how far short it is.
class _LineStatusChip extends StatelessWidget {
  const _LineStatusChip({required this.line});

  final StatementLine line;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (line.status) {
      LedgerLineStatus.paid => ('PAID', Colors.green.shade700),
      LedgerLineStatus.partial => ('PARTIAL', Colors.orange.shade800),
      LedgerLineStatus.outstanding => ('OUTSTANDING', Colors.red.shade700),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        if (line.status == LedgerLineStatus.partial)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '${formatStatementAmount(line.paidCents)} received',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
              textAlign: TextAlign.right,
            ),
          ),
      ],
    );
  }
}
