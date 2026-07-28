import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/database_provider.dart';
import '../clients_projects/clients_projects_screen.dart';
import 'onboarding/welcome_card.dart';
import 'timer/active_timers_list.dart';
import 'timer/recent_timers_list.dart';
import 'timer/timer_start_form.dart';

/// Dashboard home tab (index 0): the start-a-timer form stays pinned at the top
/// while the Active Timers and Recent Activity lists scroll beneath it. Ported
/// from the original app's dashboard timer area.
///
/// On the very first run it also shows a one-time, dismissible welcome card
/// (gated by the `settings.setupCompleted` flag). Dismissing it — by either
/// button or the barrier — marks setup seen so it never reappears; "Get Started"
/// also opens the Clients & Projects screen (a project is the item that unblocks
/// the timer).
class DashboardHomeTab extends ConsumerStatefulWidget {
  const DashboardHomeTab({super.key});

  @override
  ConsumerState<DashboardHomeTab> createState() => _DashboardHomeTabState();
}

class _DashboardHomeTabState extends ConsumerState<DashboardHomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowWelcome());
  }

  Future<void> _maybeShowWelcome() async {
    final db = ref.read(databaseProvider);
    final settings = await db.settingsDao.getSettings();
    if (settings == null || settings.setupCompleted != 0) return; // seen already
    if (!mounted) return;

    final action = await showWelcomeCard(context);

    // Mark setup seen regardless of how the card was dismissed (one-time).
    await db.settingsDao.saveSettings(
      settings.toCompanion(true).copyWith(setupCompleted: const Value(1)),
    );

    if (action == WelcomeAction.getStarted && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ClientsProjectsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed: always-visible timer form.
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TimerStartForm(),
        ),
        // Scrolling: the records scroll past the pinned form.
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: const [
              Text('Active Timers',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ActiveTimersList(),
              SizedBox(height: 20),
              Text('Recent Activity (7 Days)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              RecentTimersList(),
            ],
          ),
        ),
      ],
    );
  }
}
