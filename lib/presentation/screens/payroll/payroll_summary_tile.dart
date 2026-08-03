import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/payroll_providers.dart';
import 'payroll_format.dart';

/// One employee card in the Project Disbursements view. Collapsed it shows the
/// name + Hours/Earned/Paid/Balance and a "Log Payment" action; expanded it
/// reveals that employee's payment history for the selected range (newest
/// first), each line showing date, amount, linked project, and note.
///
/// Balance is highlighted red when positive (still owed) and green when negative
/// (overpaid). [payments] are pre-filtered to this employee and expected to be
/// sorted newest-first by the caller.
class PayrollSummaryTile extends StatelessWidget {
  const PayrollSummaryTile({
    super.key,
    required this.row,
    required this.payments,
    required this.projectNameById,
    required this.onLogPayment,
  });

  final PayrollSummaryRow row;
  final List<DbWorkerPayment> payments;
  final Map<int, String> projectNameById;
  final VoidCallback onLogPayment;

  @override
  Widget build(BuildContext context) {
    final balance = row.balanceCents;
    final balanceColor = balance > 0
        ? Colors.red.shade700
        : (balance < 0 ? Colors.green.shade700 : null);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      // Drop ExpansionTile's default top/bottom dividers so it reads as a card.
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      row.employeeName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: onLogPayment,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Log Payment'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _stat('Hours', payrollHours(row.hours)),
                  _stat('Earned', payrollMoney(row.earnedCents)),
                  _stat('Paid', payrollMoney(row.paidCents)),
                  _stat('Balance', payrollMoney(balance), color: balanceColor),
                ],
              ),
            ],
          ),
          children: [
            const Divider(height: 1),
            const SizedBox(height: 8),
            if (payments.isEmpty)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('No payments in this period.',
                    style: TextStyle(color: Colors.grey)),
              )
            else
              for (final p in payments) _PaymentLine(
                payment: p,
                projectName: p.projectId == null
                    ? null
                    : projectNameById[p.projectId],
              ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

/// A single payment row inside an expanded card: date + amount on the first
/// line, then the linked project and/or note (the cheque memo) below.
class _PaymentLine extends StatelessWidget {
  const _PaymentLine({required this.payment, this.projectName});

  final DbWorkerPayment payment;
  final String? projectName;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(payment.paymentDate);
    final dateStr = date == null
        ? payment.paymentDate
        : DateFormat('MMM d, yyyy').format(date);
    final note = (payment.note ?? '').trim();

    final detail = <String>[
      if (projectName != null && projectName!.isNotEmpty) projectName!,
      if (note.isNotEmpty) note,
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateStr, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(payrollMoney(payment.amount),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          if (detail.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(detail,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade700)),
            ),
        ],
      ),
    );
  }
}
