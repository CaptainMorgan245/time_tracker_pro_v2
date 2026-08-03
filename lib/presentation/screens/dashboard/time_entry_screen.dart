import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/client_project_providers.dart';
import '../../providers/reference_data_providers.dart';
import '../../providers/time_entry_providers.dart';
import '../../widgets/async_value_view.dart';
import 'time_entry/manual_time_entry_form.dart';

/// Manual time-entry screen (ported from the original app's `TimeTrackerPage`,
/// reached from the drawer as "Time Entry Form").
///
/// The widget is intentionally thin: filter state lives in
/// [timeEntryFilterProvider], and the filtered rows + summary totals come from
/// [timeEntryRowsProvider] / [timeEntrySummaryProvider]. The screen only watches
/// that derived data and drives the add/edit/delete dialogs.
class TimeEntryScreen extends ConsumerStatefulWidget {
  const TimeEntryScreen({super.key});

  @override
  ConsumerState<TimeEntryScreen> createState() => _TimeEntryScreenState();
}

class _TimeEntryScreenState extends ConsumerState<TimeEntryScreen> {
  Future<void> _openForm({DbTimeEntry? entry}) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry == null ? 'Add Time Record' : 'Edit Time Record',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ManualTimeEntryForm(
                  initial: entry,
                  onSaved: () => Navigator.of(dialogContext).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _delete(DbTimeEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete time record?'),
        content: const Text('This record will be removed from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(timeEntryActionsProvider.notifier).delete(entry.id);
    final s = ref.read(timeEntryActionsProvider);
    if (s.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete record: ${s.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Entry Form'),
        actions: [
          TextButton.icon(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Record'),
          ),
        ],
      ),
      body: Column(
        children: [
          const _FilterCard(),
          Expanded(child: _recordsList()),
        ],
      ),
    );
  }

  Widget _recordsList() {
    return AsyncValueView<List<TimeEntryRow>>(
      value: ref.watch(timeEntryRowsProvider),
      builder: (rows) {
        if (rows.isEmpty) {
          return const Center(child: Text('No time records found.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 80),
          itemCount: rows.length,
          separatorBuilder: (_, __) => const SizedBox(height: 2),
          itemBuilder: (context, i) => _recordTile(rows[i]),
        );
      },
    );
  }

  Widget _recordTile(TimeEntryRow row) {
    final e = row.entry;
    final date = row.startTime == null
        ? '--'
        : DateFormat('MM/dd').format(row.startTime!);
    final details = e.workDetails?.trim();
    final line2 = [
      row.clientName,
      row.costCodeName,
      row.employeeName,
      if (details != null && details.isNotEmpty) details,
    ].join(' · ');

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
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
                    '$date | ${row.projectName} | '
                    '${row.hours.toStringAsFixed(2)}h · \$${row.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    line2,
                    style: const TextStyle(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(),
              onPressed: () => _openForm(entry: e),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(),
              onPressed: () => _delete(e),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

/// Filter card: reads/writes [timeEntryFilterProvider] and shows the derived
/// [timeEntrySummaryProvider] totals. Reference lists are only used to populate
/// the dropdown options.
class _FilterCard extends ConsumerWidget {
  const _FilterCard();

  static const _dense = InputDecoration(
    border: OutlineInputBorder(),
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(timeEntryFilterProvider);
    final notifier = ref.read(timeEntryFilterProvider.notifier);

    final clients =
        ref.watch(clientsStreamProvider).asData?.value ?? const <DbClient>[];
    final projects =
        ref.watch(projectsStreamProvider).asData?.value ?? const <DbProject>[];
    final employees = ref.watch(employeesStreamProvider).asData?.value ??
        const <DbEmployee>[];
    final costCodes = ref.watch(costCodesStreamProvider).asData?.value ??
        const <DbCostCode>[];
    final summary = ref.watch(timeEntrySummaryProvider).asData?.value;

    final clientValue =
        clients.any((c) => c.id == filter.clientId) ? filter.clientId : null;
    final projectValue =
        projects.any((p) => p.id == filter.projectId) ? filter.projectId : null;
    final employeeValue = employees.any((e) => e.id == filter.employeeId)
        ? filter.employeeId
        : null;
    final costCodeValue = (filter.costCodeId == -1 ||
            costCodes.any((c) => c.id == filter.costCodeId))
        ? filter.costCodeId
        : null;

    Future<void> pickStart() async {
      final date = await showDatePicker(
        context: context,
        initialDate: filter.startDate ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
      );
      if (date != null) notifier.setStartDate(date);
    }

    Future<void> pickEnd() async {
      final date = await showDatePicker(
        context: context,
        initialDate: filter.endDate ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
      );
      if (date != null) notifier.setEndDate(date);
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: date range
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      filter.startDate == null
                          ? 'Start Date'
                          : DateFormat('MM/dd/yy').format(filter.startDate!),
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: pickStart,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      filter.endDate == null
                          ? 'End Date'
                          : DateFormat('MM/dd/yy').format(filter.endDate!),
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: pickEnd,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row 2: client | project
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: clientValue,
                    isExpanded: true,
                    decoration: _dense.copyWith(labelText: 'Client'),
                    items: [
                      const DropdownMenuItem<int>(
                          value: null, child: Text('All Clients')),
                      ...clients.map((c) => DropdownMenuItem(
                          value: c.id,
                          child:
                              Text(c.name, overflow: TextOverflow.ellipsis))),
                    ],
                    onChanged: notifier.setClient,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: projectValue,
                    isExpanded: true,
                    decoration: _dense.copyWith(labelText: 'Project'),
                    items: [
                      const DropdownMenuItem<int>(
                          value: null, child: Text('All Projects')),
                      ...projects
                          .where((p) => filter.clientId == null ||
                              p.clientId == filter.clientId)
                          .map((p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.projectName,
                                  overflow: TextOverflow.ellipsis))),
                    ],
                    onChanged: notifier.setProject,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row 3: employee | cost code
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: employeeValue,
                    isExpanded: true,
                    decoration: _dense.copyWith(labelText: 'Employee'),
                    items: [
                      const DropdownMenuItem<int>(
                          value: null, child: Text('All Employees')),
                      ...employees.map((e) => DropdownMenuItem(
                          value: e.id,
                          child:
                              Text(e.name, overflow: TextOverflow.ellipsis))),
                    ],
                    onChanged: notifier.setEmployee,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: costCodeValue,
                    isExpanded: true,
                    decoration: _dense.copyWith(labelText: 'Cost Code'),
                    items: [
                      const DropdownMenuItem<int>(
                          value: null, child: Text('All Cost Codes')),
                      const DropdownMenuItem<int>(
                          value: -1, child: Text('No Cost Code')),
                      ...costCodes.map((c) => DropdownMenuItem(
                          value: c.id,
                          child:
                              Text(c.name, overflow: TextOverflow.ellipsis))),
                    ],
                    onChanged: notifier.setCostCode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Summary line (derived)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Records: ${summary?.recordCount ?? 0}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 11)),
                  Text('Hours: ${(summary?.totalHours ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 11)),
                  Text(
                      'Value: \$${(summary?.totalValue ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
