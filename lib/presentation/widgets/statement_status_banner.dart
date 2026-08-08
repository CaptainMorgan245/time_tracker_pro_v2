import 'package:flutter/material.dart';

import '../providers/statement_providers.dart';
import 'statement_row.dart';

/// The single place a project's statement status is turned into words, so the
/// client statement row and the project statement screen always say the same
/// thing about the same project.
///
/// The rule the wording protects: an unfinished project never states a balance.
/// Its final contract amount can still move — change orders, unbilled extras —
/// so paid-to-date is the only figure that is actually true, and that is all it
/// is allowed to claim.
///
/// The converse matters just as much: a *completed* project whose invoices are
/// all paid says "Paid in Full" outright, with no reference to invoice type or
/// to whether the total billed matched the contract price. Discounts and
/// write-offs are deliberate, and a project settled for less than its contract
/// price is still settled.
class StatementStatusText {
  const StatementStatusText({required this.headline, this.detail, required this.color});

  /// The status itself, e.g. "Paid in Full" or "Balance Owing $2,400.00".
  final String headline;

  /// Supporting figure, where one exists and isn't already in [headline].
  final String? detail;

  final Color color;
}

StatementStatusText statementStatusText(ProjectStatement s) {
  final paid = formatStatementAmount(s.lifetimePaidCents);
  return switch (s.status) {
    ProjectStatementStatus.inProgress => StatementStatusText(
        headline: 'Paid to date: $paid',
        detail: 'project not yet complete',
        color: Colors.blueGrey.shade700,
      ),
    ProjectStatementStatus.notInvoiced => StatementStatusText(
        headline: 'No invoices on this project',
        color: Colors.grey.shade600,
      ),
    ProjectStatementStatus.paidInFull => StatementStatusText(
        headline: 'Paid in Full',
        color: Colors.green.shade800,
      ),
    ProjectStatementStatus.balanceOwing => StatementStatusText(
        headline: 'Balance Owing ${formatStatementAmount(s.balanceOwingCents)}',
        color: Colors.red.shade700,
      ),
  };
}

/// One-line status, for a client-statement row.
class StatementStatusLine extends StatelessWidget {
  const StatementStatusLine({super.key, required this.statement});

  final ProjectStatement statement;

  @override
  Widget build(BuildContext context) {
    final s = statementStatusText(statement);
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: s.headline,
          style: TextStyle(fontWeight: FontWeight.w600, color: s.color),
        ),
        if (s.detail != null)
          TextSpan(
            text: ' — ${s.detail}',
            style: TextStyle(color: Colors.grey.shade700),
          ),
      ]),
      style: const TextStyle(fontSize: 12),
    );
  }
}

/// Full-width status banner, for the top of a project statement.
class StatementStatusBanner extends StatelessWidget {
  const StatementStatusBanner({super.key, required this.statement});

  final ProjectStatement statement;

  @override
  Widget build(BuildContext context) {
    final s = statementStatusText(statement);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: s.color.withValues(alpha: 0.10),
        border: Border(left: BorderSide(color: s.color, width: 4)),
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.headline,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: s.color),
          ),
          if (s.detail != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                s.detail!,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
              ),
            ),
        ],
      ),
    );
  }
}
