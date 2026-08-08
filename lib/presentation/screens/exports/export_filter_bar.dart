import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/client_project_providers.dart';
import '../../providers/export/export_filter.dart';
import '../../providers/export/expense_export_providers.dart';
import '../../providers/reference_data_providers.dart';
import 'export_date_range_field.dart';

/// The filter controls for the expense report: period, scope, then the
/// narrowing dimensions (client, project, cost code, category).
///
/// Every control writes to [exportFilterProvider] and nothing else — the table
/// below recomputes off that, so there is no "apply" step and no local state to
/// keep in sync.
///
/// Dimensions this report doesn't honour (employee) simply aren't rendered
/// here; the filter object carries them for the labour reports.
class ExportFilterBar extends ConsumerWidget {
  const ExportFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(exportFilterProvider);
    final notifier = ref.read(exportFilterProvider.notifier);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ExportDateRangeField(),
            const SizedBox(height: 12),
            _ScopeSelector(scope: filter.scope, onChanged: notifier.setScope),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _ClientDropdown(filter: filter)),
                const SizedBox(width: 12),
                Expanded(child: _ProjectDropdown(filter: filter)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _CostCodeDropdown(filter: filter)),
                const SizedBox(width: 12),
                Expanded(child: _CategoryDropdown(filter: filter)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Company vs project expenses. A segmented control rather than a dropdown:
/// there are exactly three mutually-exclusive options and which one is active
/// changes what the whole report means, so it should be readable at a glance.
class _ScopeSelector extends StatelessWidget {
  const _ScopeSelector({required this.scope, required this.onChanged});

  final ExpenseScope scope;
  final ValueChanged<ExpenseScope> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ExpenseScope>(
      segments: const [
        ButtonSegment(value: ExpenseScope.all, label: Text('All')),
        ButtonSegment(value: ExpenseScope.projectOnly, label: Text('Project')),
        ButtonSegment(value: ExpenseScope.companyOnly, label: Text('Company')),
      ],
      selected: {scope},
      showSelectedIcon: false,
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

class _ClientDropdown extends ConsumerWidget {
  const _ClientDropdown({required this.filter});

  final ExportFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsA = ref.watch(clientsStreamProvider);
    return clientsA.when(
      loading: () => const _LoadingField(label: 'Client'),
      error: (_, __) => const _ErrorField(label: 'Client'),
      data: (clients) {
        final sorted = [...clients]
          ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        final ids = sorted.map((c) => c.id).toSet();
        return DropdownButtonFormField<int?>(
          isExpanded: true,
          decoration: _dec('Client'),
          initialValue: ids.contains(filter.clientId) ? filter.clientId : null,
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text('All clients')),
            ...sorted.map((c) => DropdownMenuItem<int?>(
                  value: c.id,
                  child: Text(c.name, overflow: TextOverflow.ellipsis),
                )),
          ],
          onChanged: (v) => ref.read(exportFilterProvider.notifier).setClient(v),
        );
      },
    );
  }
}

class _ProjectDropdown extends ConsumerWidget {
  const _ProjectDropdown({required this.filter});

  final ExportFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsA = ref.watch(projectsStreamProvider);
    return projectsA.when(
      loading: () => const _LoadingField(label: 'Project'),
      error: (_, __) => const _ErrorField(label: 'Project'),
      data: (projects) {
        // Client-scoped, and the internal company project is deliberately left
        // in: company expenses are filed under it, so excluding it would make
        // that side of the report unreachable by project.
        final visible = [
          for (final p in projects)
            if (filter.clientId == null || p.clientId == filter.clientId) p
        ]..sort((a, b) => a.projectName
            .toLowerCase()
            .compareTo(b.projectName.toLowerCase()));
        final ids = visible.map((p) => p.id).toSet();
        return DropdownButtonFormField<int?>(
          isExpanded: true,
          decoration: _dec('Project'),
          initialValue: ids.contains(filter.projectId) ? filter.projectId : null,
          items: [
            const DropdownMenuItem<int?>(
                value: null, child: Text('All projects')),
            ...visible.map((p) => DropdownMenuItem<int?>(
                  value: p.id,
                  child: Text(_projectLabel(p), overflow: TextOverflow.ellipsis),
                )),
          ],
          onChanged: (v) =>
              ref.read(exportFilterProvider.notifier).setProject(v),
        );
      },
    );
  }

  String _projectLabel(DbProject p) =>
      p.isInternal != 0 ? '${p.projectName} (internal)' : p.projectName;
}

class _CostCodeDropdown extends ConsumerWidget {
  const _CostCodeDropdown({required this.filter});

  final ExportFilter filter;

  /// Sentinel for "expenses with no cost code at all", matching the convention
  /// `TimeEntryFilter` already uses.
  static const int _noCostCode = -1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codesA = ref.watch(costCodesStreamProvider);
    return codesA.when(
      loading: () => const _LoadingField(label: 'Cost code'),
      error: (_, __) => const _ErrorField(label: 'Cost code'),
      data: (codes) {
        final sorted = [...codes]
          ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        final ids = {...sorted.map((c) => c.id), _noCostCode};
        return DropdownButtonFormField<int?>(
          isExpanded: true,
          decoration: _dec('Cost code'),
          initialValue:
              ids.contains(filter.costCodeId) ? filter.costCodeId : null,
          items: [
            const DropdownMenuItem<int?>(
                value: null, child: Text('All cost codes')),
            const DropdownMenuItem<int?>(
                value: _noCostCode, child: Text('No cost code')),
            ...sorted.map((c) => DropdownMenuItem<int?>(
                  value: c.id,
                  child: Text(c.name, overflow: TextOverflow.ellipsis),
                )),
          ],
          onChanged: (v) =>
              ref.read(exportFilterProvider.notifier).setCostCode(v),
        );
      },
    );
  }
}

class _CategoryDropdown extends ConsumerWidget {
  const _CategoryDropdown({required this.filter});

  final ExportFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesA = ref.watch(expenseCategoryOptionsProvider);
    return categoriesA.when(
      loading: () => const _LoadingField(label: 'Category'),
      error: (_, __) => const _ErrorField(label: 'Category'),
      data: (categories) {
        final selected = categories.contains(filter.expenseCategory)
            ? filter.expenseCategory
            : null;
        return DropdownButtonFormField<String?>(
          isExpanded: true,
          decoration: _dec('Category'),
          initialValue: selected,
          items: [
            const DropdownMenuItem<String?>(
                value: null, child: Text('All categories')),
            ...categories.map((c) => DropdownMenuItem<String?>(
                  value: c,
                  child: Text(c, overflow: TextOverflow.ellipsis),
                )),
          ],
          onChanged: (v) =>
              ref.read(exportFilterProvider.notifier).setExpenseCategory(v),
        );
      },
    );
  }
}

InputDecoration _dec(String label) => InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      filled: true,
      isDense: true,
    );

class _LoadingField extends StatelessWidget {
  const _LoadingField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: _dec(label),
      child: const SizedBox(
        height: 20,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

class _ErrorField extends StatelessWidget {
  const _ErrorField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: _dec(label),
      child: const Text('Could not load'),
    );
  }
}
