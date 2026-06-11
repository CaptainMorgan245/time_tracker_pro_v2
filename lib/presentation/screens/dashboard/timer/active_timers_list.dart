import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/drift/app_database.dart';
import '../../../providers/client_project_providers.dart';
import '../../../providers/reference_data_providers.dart';
import '../../../providers/timer_providers.dart';
import '../../../widgets/async_value_view.dart';

/// Shows all running timers (active = no endTime). A 1-second ticker rebuilds
/// the widget so each timer's elapsed time updates live; the underlying data
/// comes from [timeEntriesStreamProvider]. Each card offers Edit (loads the
/// entry into the start form via [editingTimerProvider]) and Stop.
class ActiveTimersList extends ConsumerStatefulWidget {
  const ActiveTimersList({super.key});

  @override
  ConsumerState<ActiveTimersList> createState() => _ActiveTimersListState();
}

class _ActiveTimersListState extends ConsumerState<ActiveTimersList> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Duration _elapsed(DbTimeEntry e, DateTime now) {
    final start = DateTime.parse(e.startTime);
    final gross = now.difference(start).inSeconds;
    final secs = (gross - e.pausedDuration).round();
    return Duration(seconds: secs < 0 ? 0 : secs);
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:'
        '${two(d.inSeconds.remainder(60))}';
  }

  Future<void> _stop(DbTimeEntry e) async {
    await ref.read(timerActionsProvider.notifier).stop(e);
    final s = ref.read(timerActionsProvider);
    if (s.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop timer: ${s.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final entriesA = ref.watch(timeEntriesStreamProvider);
    final projectsA = ref.watch(projectsStreamProvider);
    final employeesA = ref.watch(employeesStreamProvider);
    final busy = ref.watch(timerActionsProvider).isLoading;

    return AsyncValueView<List<DbTimeEntry>>(
      value: entriesA,
      builder: (entries) => AsyncValueView<List<DbProject>>(
        value: projectsA,
        builder: (projects) => AsyncValueView<List<DbEmployee>>(
          value: employeesA,
          builder: (employees) => _list(entries, projects, employees, busy),
        ),
      ),
    );
  }

  Widget _list(
    List<DbTimeEntry> entries,
    List<DbProject> projects,
    List<DbEmployee> employees,
    bool busy,
  ) {
    final active =
        entries.where((e) => e.endTime == null && e.isDeleted == 0).toList();
    if (active.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('No active timers.')),
      );
    }

    final projectName = {for (final p in projects) p.id: p.projectName};
    final employeeName = {for (final e in employees) e.id: e.name};

    final now = DateTime.now();
    return Column(
      children: active
          .map((e) => _card(e, now, projectName, employeeName, busy))
          .toList(),
    );
  }

  Widget _card(
    DbTimeEntry e,
    DateTime now,
    Map<int, String> projectName,
    Map<int, String> employeeName,
    bool busy,
  ) {
    final employee = e.employeeId == null ? null : employeeName[e.employeeId];
    final details = e.workDetails;
    final subtitle = [
      if (employee != null) 'Employee: $employee',
      if (details != null && details.isNotEmpty) 'Details: $details',
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      color: Colors.blueGrey.shade50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectName[e.projectId] ?? 'Unknown project',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _format(_elapsed(e, now)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit, size: 18, color: Colors.blueGrey),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(),
              onPressed: () => ref.read(editingTimerProvider.notifier).set(e),
            ),
            const SizedBox(width: 12),
            IconButton(
              tooltip: 'Stop',
              icon: const Icon(Icons.stop_circle, size: 22, color: Colors.red),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(),
              onPressed: busy ? null : () => _stop(e),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
