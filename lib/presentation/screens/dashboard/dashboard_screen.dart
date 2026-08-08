import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/cost_entry_providers.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../clients_projects/clients_projects_screen.dart';
import '../data_management_screen.dart';
import '../database_viewer_screen.dart';
import '../payroll_screen.dart';
import '../settings_screen.dart';
import '../statements/client_statement_screen.dart';
import '../statements/project_statement_screen.dart';
import 'analytics_screen.dart';
import 'cost_entry_screen.dart';
import 'dashboard_home_tab.dart';
import 'invoices_screen.dart';
import 'time_entry_screen.dart';

/// Main shell, ported from the original app's DashboardScreen: a dynamic AppBar
/// title, a navigation drawer, an [IndexedStack] body over the four main areas,
/// and a fixed bottom navigation bar to switch between them.
///
/// The four areas are placeholders for now (see the `dashboard/` screens).
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late int _selectedIndex = widget.initialIndex;

  /// Amount-lookup state for the Cost Entry tab (index 1). The query text is
  /// mirrored into [costEntryAmountSearchProvider] for the screen to read.
  bool _isSearching = false;
  final TextEditingController _amountSearch = TextEditingController();

  static const _titles = ['Dashboard', 'Cost Entry', 'Analytics', 'Invoices'];

  static const _pages = [
    DashboardHomeTab(),
    CostEntryScreen(),
    AnalyticsScreen(),
    InvoicesScreen(),
  ];

  void _onItemTapped(int index) {
    // Leaving the Cost Entry tab cancels any active amount lookup.
    if (index != 1 && (_isSearching || _amountSearch.text.isNotEmpty)) {
      _amountSearch.clear();
      ref.read(costEntryAmountSearchProvider.notifier).clear();
      _isSearching = false;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  void dispose() {
    _amountSearch.dispose();
    super.dispose();
  }

  void _open(Widget screen) {
    Navigator.pop(context); // close the drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Cost Entry tab gets an amount-lookup search (ported from v1): a $
        // search toggle that swaps the title for a numeric field; its text drives
        // the records list via costEntryAmountSearchProvider.
        title: _selectedIndex == 1 && _isSearching
            ? TextField(
                controller: _amountSearch,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter amount…',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (v) =>
                    ref.read(costEntryAmountSearchProvider.notifier).set(v),
              )
            : Text(_titles[_selectedIndex]),
        actions: _selectedIndex == 1
            ? [
                IconButton(
                  tooltip: _isSearching
                      ? 'Close amount search'
                      : 'Search by amount',
                  icon: _isSearching
                      ? const Icon(Icons.close)
                      : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.search), Text('\$')],
                        ),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) {
                        _amountSearch.clear();
                        ref
                            .read(costEntryAmountSearchProvider.notifier)
                            .clear();
                      }
                    });
                  },
                ),
              ]
            : null,
      ),
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
              trailing: IconButton(
                icon: const Icon(Icons.help_outline),
                tooltip: 'About clients & projects',
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clients & Projects'),
                    content: const Text(
                      'A project needs a client. A client can have multiple '
                      'projects.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Got it'),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () => _open(const ClientsProjectsScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Time Entry Form'),
              onTap: () => _open(const TimeEntryScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Project Disbursements'),
              onTap: () => _open(const PayrollScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Client Statement'),
              onTap: () => _open(const ClientStatementScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Project Statement'),
              onTap: () => _open(const ProjectStatementScreen()),
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
