import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/drift/app_database.dart';
import '../../../providers/client_project_providers.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/reference_data_providers.dart';
import '../../../providers/timer_providers.dart';
import '../../../widgets/async_value_view.dart';

/// Card with the "start a timer" form, ported from the old app's TimerAddForm
/// (live-timer mode). Pick a project and employee (both required), optionally a
/// cost code and work details, then:
///   - **Start Timer** begins a timer now.
///   - **Set Time** begins a timer at a custom (earlier) start time.
///   - **Clear** resets the form.
/// When an active timer's Edit pencil populates [editingTimerProvider], the
/// form switches to Update mode to edit that running entry instead.
class TimerStartForm extends ConsumerStatefulWidget {
  const TimerStartForm({super.key});

  @override
  ConsumerState<TimerStartForm> createState() => _TimerStartFormState();
}

class _TimerStartFormState extends ConsumerState<TimerStartForm> {
  final _detailsController = TextEditingController();
  int? _projectId;
  int? _employeeId;
  int? _costCodeId;

  /// The entry being edited (Update mode), or null for a new timer.
  int? _editingId;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _projectId = null;
      _employeeId = null;
      _costCodeId = null;
      _detailsController.clear();
      _editingId = null;
    });
  }

  /// Clear button: also drop out of Update mode.
  void _clear() {
    ref.read(editingTimerProvider.notifier).set(null);
    _reset();
  }

  /// Pull the form fields from a running entry when the Edit pencil selects it.
  void _populateFrom(DbTimeEntry e) {
    setState(() {
      _editingId = e.id;
      _projectId = e.projectId;
      _employeeId = e.employeeId;
      _costCodeId = e.costCodeId;
      _detailsController.text = e.workDetails ?? '';
    });
  }

  /// Copy a past record into the form as a NEW timer: same project + employee,
  /// but cost code and work details left blank (they change day to day).
  void _copyForNewTimer(DbTimeEntry e) {
    setState(() {
      _editingId = null; // new timer, not an edit
      _projectId = e.projectId;
      _employeeId = e.employeeId;
      _costCodeId = null;
      _detailsController.clear();
    });
    // Leave any prior edit mode (safe: _editingId is now null, so the editing
    // listener won't reset the fields we just set).
    ref.read(editingTimerProvider.notifier).set(null);
  }

  double? _rateFor(int employeeId, List<DbEmployee> employees) {
    for (final e in employees) {
      if (e.id == employeeId) return e.hourlyRate;
    }
    return null;
  }

  /// Validates project + employee are chosen. Returns false (and shows a
  /// message) if not.
  bool _validate() {
    if (_projectId == null) {
      _snack('Please select a project.');
      return false;
    }
    if (_employeeId == null) {
      _snack('Please select an employee.');
      return false;
    }
    return true;
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  String? get _details =>
      _detailsController.text.trim().isEmpty ? null : _detailsController.text.trim();

  Future<void> _submitNew(List<DbEmployee> employees, {DateTime? startTime}) async {
    if (!_validate()) return;
    FocusScope.of(context).unfocus();
    await ref.read(timerActionsProvider.notifier).start(
          projectId: _projectId!,
          employeeId: _employeeId!,
          costCodeId: _costCodeId,
          workDetails: _details,
          hourlyRate: _rateFor(_employeeId!, employees),
          startTime: startTime,
        );
    if (!mounted) return;
    final s = ref.read(timerActionsProvider);
    if (s.hasError) {
      _snack('Failed to start timer: ${s.error}');
      return;
    }
    _reset();
  }

  Future<void> _submitUpdate(List<DbEmployee> employees) async {
    if (!_validate()) return;
    final entry =
        await ref.read(databaseProvider).timeEntriesDao.getById(_editingId!);
    if (entry == null) {
      _clear();
      return;
    }
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    await ref.read(timerActionsProvider.notifier).update(
          entry,
          projectId: _projectId!,
          employeeId: _employeeId!,
          costCodeId: _costCodeId,
          workDetails: _details,
          hourlyRate: _rateFor(_employeeId!, employees),
          startTime: DateTime.parse(entry.startTime),
        );
    if (!mounted) return;
    final s = ref.read(timerActionsProvider);
    if (s.hasError) {
      _snack('Failed to update timer: ${s.error}');
      return;
    }
    ref.read(editingTimerProvider.notifier).set(null);
    _reset();
  }

  /// Set Time: pick a custom start time (HHmm, 24-hour) for today and start.
  Future<void> _setTimeAndStart(List<DbEmployee> employees) async {
    if (!_validate()) return;
    final time = await _showTimeInputDialog(
      title: 'Set Start Time',
      initialDate: DateTime.now(),
    );
    if (time == null) return;
    await _submitNew(employees, startTime: time);
  }

  Future<DateTime?> _showTimeInputDialog({
    required String title,
    required DateTime initialDate,
  }) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: const InputDecoration(
            labelText: 'Time (4-digit 24-hour)',
            hintText: 'HHmm, e.g., 0830',
            helperText: 'Add 12 for 24 hr time.\nExample: 2:30 PM = 1430',
            helperMaxLines: 2,
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => Navigator.of(context).pop(true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (confirmed == true && controller.text.length == 4) {
      try {
        final hours = int.parse(controller.text.substring(0, 2));
        final minutes = int.parse(controller.text.substring(2));
        if (hours >= 0 && hours < 24 && minutes >= 0 && minutes < 60) {
          return DateTime(
              initialDate.year, initialDate.month, initialDate.day, hours, minutes);
        }
        if (mounted) _snack('Invalid time. Hours 00-23, Mins 00-59.');
      } catch (_) {
        if (mounted) _snack('Invalid format. Please use HHmm.');
      }
    } else if (confirmed == true && controller.text.isNotEmpty) {
      if (mounted) _snack('Please enter 4 digits (HHmm).');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // React to the Edit pencil selecting a running timer.
    ref.listen<DbTimeEntry?>(editingTimerProvider, (prev, next) {
      if (next != null && next.id != _editingId) {
        _populateFrom(next);
      } else if (next == null && _editingId != null) {
        _reset();
      }
    });
    // Tapping a recent record copies it in as a new timer (one-shot).
    ref.listen<DbTimeEntry?>(copyTimerProvider, (prev, next) {
      if (next == null) return;
      _copyForNewTimer(next);
      ref.read(copyTimerProvider.notifier).set(null);
    });

    final projectsA = ref.watch(projectsStreamProvider);
    final employeesA = ref.watch(employeesStreamProvider);
    final costCodesA = ref.watch(costCodesStreamProvider);
    final busy = ref.watch(timerActionsProvider).isLoading;
    return AsyncValueView<List<DbProject>>(
      value: projectsA,
      builder: (allProjects) => AsyncValueView<List<DbEmployee>>(
        value: employeesA,
        builder: (allEmployees) => AsyncValueView<List<DbCostCode>>(
          value: costCodesA,
          builder: (costCodes) => _form(
            context,
            allProjects.where((p) => p.isCompleted == 0).toList(),
            allEmployees.where((e) => e.isDeleted == 0).toList(),
            costCodes,
            busy,
          ),
        ),
      ),
    );
  }

  Widget _form(
    BuildContext context,
    List<DbProject> projects,
    List<DbEmployee> employees,
    List<DbCostCode> costCodes,
    bool busy,
  ) {
    final theme = Theme.of(context);
    // Sanitize selections so a value missing from the items list (e.g. an
    // archived project on an edited entry) doesn't break the dropdown.
    final projectValue =
        projects.any((p) => p.id == _projectId) ? _projectId : null;
    final employeeValue =
        employees.any((e) => e.id == _employeeId) ? _employeeId : null;
    final costCodeValue =
        costCodes.any((c) => c.id == _costCodeId) ? _costCodeId : null;

    final editing = _editingId != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: projectValue,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      labelText: 'Project',
                    ),
                    items: projects
                        .map((p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.projectName,
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (id) => setState(() => _projectId = id),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: employeeValue,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      labelText: 'Employee',
                    ),
                    items: employees
                        .map((e) => DropdownMenuItem(
                              value: e.id,
                              child:
                                  Text(e.name, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (id) => setState(() => _employeeId = id),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: costCodeValue,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      labelText: 'Cost Code',
                    ),
                    items: [
                      const DropdownMenuItem<int>(
                          value: null, child: Text('None')),
                      ...costCodes.map((c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name, overflow: TextOverflow.ellipsis),
                          )),
                    ],
                    onChanged: (id) => setState(() => _costCodeId = id),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _detailsController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                labelText: 'Work Details',
                hintText: 'Enter details about work performed...',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: busy ? null : _clear,
                          child: const Text('Clear', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: (editing || busy)
                              ? null
                              : () => _setTimeAndStart(employees),
                          child:
                              const Text('Set Time', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 7,
                  child: ElevatedButton(
                    onPressed: busy
                        ? null
                        : () => editing
                            ? _submitUpdate(employees)
                            : _submitNew(employees),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(editing ? 'Update' : 'Start Timer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
