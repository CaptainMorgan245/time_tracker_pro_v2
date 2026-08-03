import 'package:flutter/material.dart';

import 'coming_soon_body.dart';

/// Destination for the hub's "Company Expenses" button. Stub for now — will list
/// company-expense materials (from `companyExpensesReportProvider`).
class CompanyExpensesReportScreen extends StatelessWidget {
  const CompanyExpensesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company Expenses')),
      body: const ComingSoonBody(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Company Expenses',
      ),
    );
  }
}
