import 'package:flutter/material.dart';

import 'settings/burden_rate_tab.dart';
import 'settings/company_tax_tab.dart';
import 'settings/cost_codes_tab.dart';
import 'settings/expenses_tab.dart';
import 'settings/general_tab.dart';
import 'settings/help_tab.dart';
import 'settings/personnel_tab.dart';

/// Settings container, rebuilt from the original Time Tracker Pro app. Holds
/// only the tab scaffolding — each tab is a self-contained widget in its own
/// file under `settings/`, owning its own state and persistence.
///
/// Tab order matches the original app:
///   General & Reports · Personnel · Expenses · Cost Codes · Email · Burden Rate
///   · Company & Tax
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.initialIndex = 0});

  /// Tab to open on. 1 == Personnel (used by the timer's "no employees" empty
  /// state to deep-link straight to employee creation).
  final int initialIndex;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 7, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'General & Reports'),
            Tab(text: 'Personnel'),
            Tab(text: 'Expenses'),
            Tab(text: 'Cost Codes'),
            Tab(text: 'Email'),
            Tab(text: 'Burden Rate'),
            Tab(text: 'Company & Tax'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GeneralTab(),
          PersonnelTab(),
          ExpensesTab(),
          CostCodesTab(),
          HelpTab(),
          BurdenRateTab(),
          CompanyTaxTab(),
        ],
      ),
    );
  }
}
