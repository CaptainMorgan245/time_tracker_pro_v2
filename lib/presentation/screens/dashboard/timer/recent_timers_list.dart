import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../data/local/drift/app_database.dart';
import '../../../providers/client_project_providers.dart';
import '../../../providers/reference_data_providers.dart';
import '../../../providers/timer_providers.dart';
import '../../../widgets/async_value_view.dart';

/// Completed timers (entries with an endTime) from the last 7 days, newest
/// first. Ported from the old dashboard's "Recent Activity (7 Days)" section
/// (time entries only). Active timers are shown separately by
/// [ActiveTimersList], so they're excluded here.
class RecentTimersList extends ConsumerWidget {
  const RecentTimersList({super.key});

  double _hours(DbTimeEntry e) {
    if (e.finalBilledDurationSeconds != null) {
      return e.finalBilledDurationSeconds! / 3600.0;
    }
    if (e.endTime == null) return 0;
    final secs = DateTime.parse(e.endTime!)
            .difference(DateTime.parse(e.startTime))
            .inSeconds -
        e.pausedDuration;
    return secs <= 0 ? 0 : secs / 3600.0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesA = ref.watch(timeEntriesStreamProvider);
    final projectsA = ref.watch(projectsStreamProvider);
    final employeesA = ref.watch(employeesStreamProvider);

    return AsyncValueView<List<DbTimeEntry>>(
      value: entriesA,
      builder: (entries) => AsyncValueView<List<DbProject>>(
        value: projectsA,
        builder: (projects) => AsyncValueView<List<DbEmployee>>(
          value: employeesA,
          builder: (employees) => _list(
            entries,
            projects,
            employees,
            (e) => ref.read(copyTimerProvider.notifier).set(e),
          ),
        ),
      ),
    );
  }

  Widget _list(
    List<DbTimeEntry> entries,
    List<DbProject> projects,
    List<DbEmployee> employees,
    void Function(DbTimeEntry) onTap,
  ) {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final recent = entries
        .where((e) =>
            e.isDeleted == 0 &&
            e.endTime != null &&
            DateTime.parse(e.startTime).isAfter(cutoff))
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    if (recent.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('No recent activity.')),
      );
    }

    final projectName = {for (final p in projects) p.id: p.projectName};
    final employeeName = {for (final e in employees) e.id: e.name};

    return Column(
      children: recent.map((e) {
        final employee =
            e.employeeId == null ? null : employeeName[e.employeeId];
        final details = e.workDetails;
        final date = DateFormat('MMM d').format(DateTime.parse(e.startTime));
        final subtitle = [
          date,
          if (details != null && details.isNotEmpty) details,
          if (employee != null) 'By: $employee',
        ].join(' · ');
        return Card(
          margin: const EdgeInsets.only(bottom: 6),
          child: InkWell(
            onTap: () => onTap(e),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.access_time, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
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
                  '${_hours(e).toStringAsFixed(2)}h',
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          ),
        );
      }).toList(),
    );
  }
}
