import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../data/local/drift/app_database.dart';
import '../../../providers/client_project_providers.dart';
import '../../../providers/reference_data_providers.dart';
import '../../../providers/time_entry_providers.dart';
import '../../../widgets/async_value_view.dart';

/// Add/edit form for a manual time record, ported from the original app's
/// `TimerAddForm` (manual mode). Hosted inside the Add/Edit dialogs on the Time
/// Entry screen.
///
/// State management mirrors [TimerStartForm]: dropdown data comes straight from
/// the reference stream providers via [AsyncValueView], and the editable fields
/// are plain local state seeded synchronously in [initState]. Writes go through
/// [timeEntryActionsProvider] (which derives `finalBilledDurationSeconds` +
/// rounding). A single [_selectedDate] is combined with the HHmm Start/Stop
/// pickers to build the full start/end timestamps.
class ManualTimeEntryForm extends ConsumerStatefulWidget {
  const ManualTimeEntryForm({super.key, this.initial, required this.onSaved});

  /// The row being edited, or null for a new entry.
  final DbTimeEntry? initial;

  /// Called after a successful add/update so the host dialog can close.
  final VoidCallback onSaved;

  @override
  ConsumerState<ManualTimeEntryForm> createState() =>
      _ManualTimeEntryFormState();
}

class _ManualTimeEntryFormState extends ConsumerState<ManualTimeEntryForm> {
  final _workDetailsController = TextEditingController();
  int? _projectId;
  int? _employeeId;
  int? _costCodeId;
  DateTime _selectedDate = DateTime.now();
  DateTime? _startTime;
  DateTime? _endTime;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    // Seed editable fields synchronously from the row being edited (local state
    // is safe to set here — no provider mutation, no post-frame indirection).
    final e = widget.initial;
    if (e != null) {
      _projectId = e.projectId;
      _employeeId = e.employeeId;
      _costCodeId = e.costCodeId;
      _workDetailsController.text = e.workDetails ?? '';
      final start = DateTime.tryParse(e.startTime);
      _startTime = start;
      _endTime = e.endTime == null ? null : DateTime.tryParse(e.endTime!);
      _selectedDate = start ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _workDetailsController.dispose();
    super.dispose();
  }

  static InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      );

  // Explicit color: a bare TextStyle(fontSize: 13) with no color resolved to an
  // invisible colour inside the dialog (matching the surface), which made the
  // dropdown selections and typed text appear blank.
  static const _fieldStyle = TextStyle(fontSize: 13, color: Colors.black87);

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  /// Combines [time] (hour/minute) onto [_selectedDate].
  DateTime _onSelectedDate(DateTime time) => DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        time.hour,
        time.minute,
      );

  void _reset() {
    setState(() {
      _projectId = null;
      _employeeId = null;
      _costCodeId = null;
      _workDetailsController.clear();
      _selectedDate = DateTime.now();
      _startTime = null;
      _endTime = null;
    });
  }

  /// HHmm 24-hour time entry dialog, ported from the original
  /// `_showTimeInputDialog`. Returns the chosen time on [_selectedDate].
  Future<DateTime?> _showTimeInputDialog(String title) async {
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
      final hours = int.tryParse(controller.text.substring(0, 2));
      final minutes = int.tryParse(controller.text.substring(2));
      if (hours != null &&
          minutes != null &&
          hours >= 0 &&
          hours < 24 &&
          minutes >= 0 &&
          minutes < 60) {
        return _onSelectedDate(DateTime(0, 1, 1, hours, minutes));
      }
      _snack('Invalid time. Hours 00-23, Mins 00-59.');
    } else if (confirmed == true && controller.text.isNotEmpty) {
      _snack('Please enter 4 digits (HHmm).');
    }
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked == null) return;
    setState(() {
      _selectedDate = picked;
      // Re-anchor any chosen times onto the new date, like the original.
      if (_startTime != null) _startTime = _onSelectedDate(_startTime!);
      if (_endTime != null) _endTime = _onSelectedDate(_endTime!);
    });
  }

  Future<void> _pickStart() async {
    final t = await _showTimeInputDialog('Set Start Time');
    if (t != null) setState(() => _startTime = t);
  }

  Future<void> _pickStop() async {
    final t = await _showTimeInputDialog('Set Stop Time');
    if (t != null) setState(() => _endTime = t);
  }

  String? get _details => _workDetailsController.text.trim().isEmpty
      ? null
      : _workDetailsController.text.trim();

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_projectId == null) {
      _snack('Please select a project.');
      return;
    }
    if (_startTime == null || _endTime == null) {
      _snack('Please set both a start and stop time.');
      return;
    }
    if (_endTime!.isBefore(_startTime!)) {
      _snack('Stop time cannot be before start time.');
      return;
    }

    final actions = ref.read(timeEntryActionsProvider.notifier);
    if (_isEditing) {
      final existing =
          await ref.read(timeEntryRepositoryProvider).getById(widget.initial!.id);
      if (existing == null) {
        widget.onSaved();
        return;
      }
      await actions.update(
        existing.toCompanion(false).copyWith(
              projectId: Value(_projectId!),
              employeeId: Value(_employeeId),
              costCodeId: Value(_costCodeId),
              workDetails: Value(_details),
              startTime: Value(_startTime!.toIso8601String()),
              endTime: Value(_endTime!.toIso8601String()),
            ),
      );
    } else {
      await actions.add(
        TimeEntriesCompanion.insert(
          projectId: _projectId!,
          employeeId: Value(_employeeId),
          costCodeId: Value(_costCodeId),
          workDetails: Value(_details),
          startTime: _startTime!.toIso8601String(),
          endTime: Value(_endTime!.toIso8601String()),
        ),
      );
    }

    if (!mounted) return;
    final s = ref.read(timeEntryActionsProvider);
    if (s.hasError) {
      _snack('Failed to save time record: ${s.error}');
      return;
    }
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final projectsA = ref.watch(projectsStreamProvider);
    final employeesA = ref.watch(employeesStreamProvider);
    final costCodesA = ref.watch(costCodesStreamProvider);
    final busy = ref.watch(timeEntryActionsProvider).isLoading;

    return AsyncValueView<List<DbProject>>(
      value: projectsA,
      builder: (allProjects) => AsyncValueView<List<DbEmployee>>(
        value: employeesA,
        builder: (allEmployees) => AsyncValueView<List<DbCostCode>>(
          value: costCodesA,
          builder: (costCodes) => _form(
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
    List<DbProject> projects,
    List<DbEmployee> employees,
    List<DbCostCode> costCodes,
    bool busy,
  ) {
    // Sanitize selections so a value missing from the items list doesn't break
    // the dropdown.
    final projectValue =
        projects.any((p) => p.id == _projectId) ? _projectId : null;
    final employeeValue =
        employees.any((e) => e.id == _employeeId) ? _employeeId : null;
    final costCodeValue =
        costCodes.any((c) => c.id == _costCodeId) ? _costCodeId : null;

    String timeLabel(DateTime? dt, String prefix) =>
        dt == null ? 'Set $prefix' : '$prefix: ${DateFormat.Hm().format(dt)}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: Project | Employee | Cost Code
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: projectValue,
                isExpanded: true,
                isDense: true,
                style: _fieldStyle,
                decoration: _dec('Project *'),
                hint: const Text('Select project', style: _fieldStyle),
                items: projects
                    .map((p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.projectName,
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _projectId = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: employeeValue,
                isExpanded: true,
                isDense: true,
                style: _fieldStyle,
                decoration: _dec('Employee'),
                hint: const Text('Select employee', style: _fieldStyle),
                items: [
                  const DropdownMenuItem<int>(value: null, child: Text('None')),
                  ...employees.map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name, overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: (v) => setState(() => _employeeId = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: costCodeValue,
                isExpanded: true,
                isDense: true,
                style: _fieldStyle,
                decoration: _dec('Cost Code'),
                hint: const Text('Select cost code', style: _fieldStyle),
                items: [
                  const DropdownMenuItem<int>(value: null, child: Text('None')),
                  ...costCodes.map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name, overflow: TextOverflow.ellipsis),
                      )),
                ],
                onChanged: (v) => setState(() => _costCodeId = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _workDetailsController,
          style: _fieldStyle,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: false,
          enableSuggestions: false,
          decoration: _dec('Work Details'),
          maxLines: 1,
        ),
        const SizedBox(height: 8),
        // Row: Date | Start | Stop
        Row(
          children: [
            Expanded(
              flex: 5,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(DateFormat.yMd().format(_selectedDate),
                    style: _fieldStyle),
                onPressed: busy ? null : _pickDate,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: OutlinedButton(
                onPressed: busy ? null : _pickStart,
                child:
                    Text(timeLabel(_startTime, 'Start'), style: _fieldStyle),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 4,
              child: OutlinedButton(
                onPressed: busy ? null : _pickStop,
                child: Text(timeLabel(_endTime, 'Stop'), style: _fieldStyle),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row: Clear | Add/Update
        Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: busy ? null : _reset,
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                child: const Text('Clear'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: FilledButton(
                onPressed: busy ? null : _submit,
                style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                child: Text(_isEditing ? 'Update Record' : 'Add Record'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
