import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/export/export_filter.dart';
import '../../exports/expense_export_screen.dart';

/// Destination for the hub's "Select Data" button — the entry point for
/// reporting and export.
///
/// Lists the available reports. The three expense entries are the same report
/// under different [ExpenseScope]s rather than three separate reports: they
/// share one provider, one column set and one screen, and differ only in which
/// side of the company/project divide they cover. Choosing one seeds the filter
/// and leaves the period alone, so switching between them keeps the month the
/// user is working in.
///
/// Labour / personnel reports join this list as they land.
class SelectDataScreen extends ConsumerWidget {
  const SelectDataScreen({super.key});

  void _open(BuildContext context, WidgetRef ref, ExpenseScope scope) {
    ref.read(exportFilterProvider.notifier).applyPreset(scope);
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ExpenseExportScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Export')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _ReportTile(
            icon: Icons.credit_card,
            title: 'All Expenses',
            detail:
                'Every expense in the period, project and company alike — for '
                'reconciling a card or bank statement.',
            onTap: () => _open(context, ref, ExpenseScope.all),
          ),
          _ReportTile(
            icon: Icons.work_outline,
            title: 'Expenses by Project',
            detail: 'Project-attached costs only, grouped by project.',
            onTap: () => _open(context, ref, ExpenseScope.projectOnly),
          ),
          _ReportTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Company Expenses',
            detail: 'Company overhead only.',
            onTap: () => _open(context, ref, ExpenseScope.companyOnly),
          ),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.titleMedium),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right),
      isThreeLine: true,
      onTap: onTap,
    );
  }
}
