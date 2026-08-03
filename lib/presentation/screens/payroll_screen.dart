import 'package:flutter/material.dart';

import 'payroll/payroll_view.dart';

/// Project Disbursements screen — a pushed route (owns its own `Scaffold`/
/// `AppBar`) with a single view: company-wide earned/paid/balance per employee,
/// each card expandable to reveal that employee's payment history for the
/// selected date range. All data comes from the payroll providers; this screen
/// adds no calculation logic.
class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Disbursements')),
      body: const PayrollView(),
    );
  }
}
