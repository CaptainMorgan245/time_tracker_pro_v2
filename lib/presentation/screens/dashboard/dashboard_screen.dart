import 'package:flutter/material.dart';

import '../../widgets/app_bottom_nav_bar.dart';
import '../clients_projects/clients_projects_screen.dart';
import '../data_management_screen.dart';
import '../database_viewer_screen.dart';
import '../settings_screen.dart';
import 'analytics_screen.dart';
import 'cost_entry_screen.dart';
import 'dashboard_home_tab.dart';
import 'invoices_screen.dart';

/// Main shell, ported from the original app's DashboardScreen: a dynamic AppBar
/// title, a navigation drawer, an [IndexedStack] body over the four main areas,
/// and a fixed bottom navigation bar to switch between them.
///
/// The four areas are placeholders for now (see the `dashboard/` screens).
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedIndex = widget.initialIndex;

  static const _titles = ['Dashboard', 'Cost Entry', 'Analytics', 'Invoices'];

  static const _pages = [
    DashboardHomeTab(),
    CostEntryScreen(),
    AnalyticsScreen(),
    InvoicesScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  void _open(Widget screen) {
    Navigator.pop(context); // close the drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Time Tracker Pro',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.pop(context); // close the drawer
                _onItemTapped(0); // the dashboard IS the home tab (index 0)
              },
            ),
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text('Clients & Projects'),
              onTap: () => _open(const ClientsProjectsScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => _open(const SettingsScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.storage_outlined),
              title: const Text('Data Management'),
              onTap: () => _open(const DataManagementScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined),
              title: const Text('Database Viewer (Dev)'),
              onTap: () => _open(const DatabaseViewerScreen()),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
