import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/client_project_providers.dart';
import '../../providers/payroll_providers.dart';
import '../../widgets/async_value_view.dart';
import 'log_payment_dialog.dart';
import 'payroll_filter_bar.dart';
import 'payroll_summary_tile.dart';

/// The single Project Disbursements view: a date-range filter over a list of
/// per-employee cards. Each card shows Hours/Earned/Paid/Balance for the range
/// and expands to that employee's payment history (newest first).
///
/// One date range drives everything — the running totals AND the visible
/// payment history — so it opens on the year's YTD figures and narrows to a
/// month/period on demand. Balance stays company-wide (a payment's project link
/// is record-keeping only and never changes a balance).
class PayrollView extends ConsumerWidget {
  const PayrollView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(payrollRangeProvider);
    final notifier = ref.read(payrollRangeProvider.notifier);
    final summaryA = ref.watch(payrollSummaryProvider(range));
    // Company-wide payments in range (no project filter), newest first.
    final paymentsA = ref.watch(payrollPaymentsProvider(
        PayrollQuery(start: range.start, end: range.end)));

    // Project names for the "linked project" line on each payment — a
    // supplementary lookup, so an empty map while projects load is harmless.
    final projects = ref.watch(projectsStreamProvider).asData?.value ?? const [];
    final projectNameById = {for (final p in projects) p.id: p.projectName};

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: PayrollDateRangeFields(
            start: range.start,
            end: range.end,
            onStart: notifier.setStart,
            onEnd: notifier.setEnd,
          ),
        ),
        Expanded(
          child: AsyncValueView<List<PayrollSummaryRow>>(
            value: summaryA,
            builder: (rows) {
              if (rows.isEmpty) {
                return const Center(child: Text('No employees found.'));
              }
              return AsyncValueView<List<DbWorkerPayment>>(
                value: paymentsA,
                builder: (payments) {
                  // Group payments by employee (already newest-first).
                  final byEmployee = <int, List<DbWorkerPayment>>{};
                  for (final p in payments) {
                    (byEmployee[p.employeeId] ??= []).add(p);
                  }
                  return ListView.builder(
                    itemCount: rows.length,
                    itemBuilder: (context, i) {
                      final row = rows[i];
                      return PayrollSummaryTile(
                        row: row,
                        payments: byEmployee[row.employeeId] ?? const [],
                        projectNameById: projectNameById,
                        onLogPayment: () => logPayment(
                          context,
                          ref,
                          employeeId: row.employeeId,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
