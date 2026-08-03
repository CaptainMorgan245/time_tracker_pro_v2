import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/drift/app_database.dart';
import '../../../providers/analytics_providers.dart';
import '../../../providers/client_project_providers.dart';

/// The two top dropdowns from v1: a Report Type selector (Active/Completed) and
/// a project selector (All Projects + the matching project list). Both drive the
/// shared [analyticsSelectionProvider] — the project chosen here is what the
/// destination screens use.
class AnalyticsReportSelector extends ConsumerWidget {
  const AnalyticsReportSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(analyticsSelectionProvider);
    final projectsA = ref.watch(projectsStreamProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<AnalyticsReportType>(
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Report Type',
              border: OutlineInputBorder(),
              filled: true,
            ),
            value: selection.reportType,
            items: const [
              DropdownMenuItem(
                value: AnalyticsReportType.activeProjects,
                child: Text('Active Projects'),
              ),
              DropdownMenuItem(
                value: AnalyticsReportType.completedProjects,
                child: Text('Completed Projects'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(analyticsSelectionProvider.notifier)
                    .setReportType(value);
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: _projectDropdown(context, ref, selection, projectsA),
        ),
      ],
    );
  }

  Widget _projectDropdown(
    BuildContext context,
    WidgetRef ref,
    AnalyticsSelection selection,
    AsyncValue<List<DbProject>> projectsA,
  ) {
    final active =
        selection.reportType == AnalyticsReportType.activeProjects;
    final label = active ? 'Select Active Project' : 'Select Completed Project';

    return projectsA.when(
      loading: () => InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Loading…',
          border: OutlineInputBorder(),
          filled: true,
        ),
        child: const SizedBox(
          height: 24,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
      error: (e, _) => InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
        ),
        child: const Text('Could not load projects'),
      ),
      data: (projects) {
        final filtered = projects
            .where((p) => active ? p.isCompleted == 0 : p.isCompleted != 0)
            .toList()
          ..sort((a, b) => a.projectName.compareTo(b.projectName));

        // Guard the value against a stale id not in the current list.
        final ids = filtered.map((p) => p.id).toSet();
        final value = (selection.selectedProjectId != null &&
                ids.contains(selection.selectedProjectId))
            ? selection.selectedProjectId
            : null;

        return DropdownButtonFormField<int?>(
          isExpanded: true,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            filled: true,
          ),
          value: value,
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('All Projects'),
            ),
            ...filtered.map(
              (p) => DropdownMenuItem<int?>(
                value: p.id,
                child: Text(p.projectName, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
          onChanged: (v) =>
              ref.read(analyticsSelectionProvider.notifier).setProject(v),
        );
      },
    );
  }
}
