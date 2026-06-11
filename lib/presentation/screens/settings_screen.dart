import 'package:flutter/material.dart';

import 'settings/burden_rate_tab.dart';
import 'settings/company_tax_tab.dart';
import 'settings/expenses_tab.dart';
import 'settings/general_tab.dart';
import 'settings/help_tab.dart';
import 'settings/personnel_tab.dart';

/// Settings container, rebuilt from the original Time Tracker Pro app. Holds
/// only the tab scaffolding — each tab is a self-contained widget in its own
/// file under `settings/`, owning its own state and persistence.
///
/// Tab order matches the original app:
///   General & Reports · Personnel · Expenses · Email · Burden Rate · Company & Tax
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
          HelpTab(),
          BurdenRateTab(),
          CompanyTaxTab(),
        ],
      ),
    );
  }
}
