import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/analytics_providers.dart';
import 'analytics_import_helper.dart';
import 'company_expenses_report_screen.dart';
import 'personnel_report_screen.dart';
import 'select_data_screen.dart';

/// The v1 horizontal row of five colored action buttons. Visually matches the
/// original (same icons/colors/labels).
///
/// Behaviour:
///   - **Project Summary** stays on the landing page — it clears the project
///     selection so the Project Financial Summary card redisplays the full list
///     (mirrors v1's `_showProjectListReport`, just without the inline god-file
///     view-swap).
///   - **Personnel / Select Data / Company Expenses** `Navigator.push` to
///     dedicated screens.
///   - **Import Time** runs the file-pick import flow.
class AnalyticsActionButtons extends ConsumerWidget {
  const AnalyticsActionButtons({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.table_view_outlined,
            label: 'Project Summary',
            background: Colors.blue,
            foreground: Colors.white,
            onPressed: () =>
                ref.read(analyticsSelectionProvider.notifier).setProject(null),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.people_outline,
            label: 'Personnel Summary',
            background: Colors.lightGreen,
            foreground: Colors.black87,
            onPressed: () => _open(context, const PersonnelReportScreen()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.checklist_rtl_outlined,
            label: 'Select Data',
            background: Colors.red,
            foreground: Colors.white,
            onPressed: () => _open(context, const SelectDataScreen()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.account_balance_wallet,
            label: 'Company Expenses',
            background: Colors.orange,
            foreground: Colors.white,
            onPressed: () =>
                _open(context, const CompanyExpensesReportScreen()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.upload_file,
            label: 'Import Time',
            background: Colors.purple,
            foreground: Colors.white,
            onPressed: () => runTimeImport(context, ref),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onPressed,
    );
  }
}
