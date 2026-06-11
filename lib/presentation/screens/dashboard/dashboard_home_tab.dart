import 'package:flutter/material.dart';

import 'timer/active_timers_list.dart';
import 'timer/recent_timers_list.dart';
import 'timer/timer_start_form.dart';

/// Dashboard home tab (index 0): the start-a-timer form stays pinned at the top
/// while the Active Timers and Recent Activity lists scroll beneath it. Ported
/// from the original app's dashboard timer area.
class DashboardHomeTab extends StatelessWidget {
  const DashboardHomeTab({super.key});

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
