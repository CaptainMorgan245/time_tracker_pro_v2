import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/client_project_providers.dart';
import '../../providers/payroll_providers.dart';
import '../../providers/reference_data_providers.dart';

/// Opens the Log Payment dialog and, on confirm, writes via
/// [payrollActionsProvider]. Both the project and the note are optional; any
/// write error is surfaced via a snackbar.
///
/// [employeeId] / [projectId] pre-fill the form (e.g. the employee from the card
/// whose "Log Payment" button was tapped).
Future<void> logPayment(
  BuildContext context,
  WidgetRef ref, {
  int? employeeId,
  int? projectId,
}) async {
  final draft = await showDialog<_PaymentDraft>(
    context: context,
    builder: (_) => _LogPaymentDialog(
      presetEmployeeId: employeeId,
      presetProjectId: projectId,
    ),
  );
  if (draft == null || !context.mounted) return;

  await ref.read(payrollActionsProvider.notifier).addPayment(
        employeeId: draft.employeeId,
        amountCents: draft.amountCents,
        paymentDate: draft.date,
        projectId: draft.projectId,
        note: draft.note,
      );

  if (!context.mounted) return;
  final state = ref.read(payrollActionsProvider);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(state.hasError
        ? 'Could not log payment: ${state.error}'
        : 'Payment logged.'),
    backgroundColor: state.hasError ? Colors.red : Colors.green,
  ));
}

class _PaymentDraft {
  _PaymentDraft({
    required this.employeeId,
    required this.amountCents,
    required this.date,
    this.projectId,
    this.note,
  });
  final int employeeId;
  final int amountCents;
  final DateTime date;
  final int? projectId;
  final String? note;
}

class _LogPaymentDialog extends ConsumerStatefulWidget {
  const _LogPaymentDialog({this.presetEmployeeId, this.presetProjectId});
  final int? presetEmployeeId;
  final int? presetProjectId;

  @override
  ConsumerState<_LogPaymentDialog> createState() => _LogPaymentDialogState();
}

class _LogPaymentDialogState extends ConsumerState<_LogPaymentDialog> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  int? _employeeId;
  int? _projectId;
  DateTime _date = DateTime.now();
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _employeeId = widget.presetEmployeeId;
    _projectId = widget.presetProjectId;
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    if (_employeeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select an employee.')),
      );
      return;
    }
    final amt = double.tryParse(
        _amount.text.replaceAll(',', '').replaceAll('\$', '').trim());
    if (amt == null || amt <= 0) {
      setState(() => _amountError = 'Enter a valid amount');
      return;
    }
    final note = _note.text.trim();
    Navigator.of(context).pop(_PaymentDraft(
      employeeId: _employeeId!,
      amountCents: (amt * 100).round(),
      date: _date,
      projectId: _projectId,
      note: note.isEmpty ? null : note,
    ));
  }

  InputDecoration _dec(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  @override
  Widget build(BuildContext context) {
    final employees = (ref.watch(employeesStreamProvider).asData?.value ?? const [])
        .where((e) => e.isDeleted == 0)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    final projects = (ref.watch(projectsStreamProvider).asData?.value ?? const [])
        .where((p) => p.isInternal == 0)
        .toList()
      ..sort((a, b) => a.projectName.compareTo(b.projectName));

    final empIds = employees.map((e) => e.id).toSet();
    final projIds = projects.map((p) => p.id).toSet();
    final empVal =
        (_employeeId != null && empIds.contains(_employeeId)) ? _employeeId : null;
    final projVal =
        (_projectId != null && projIds.contains(_projectId)) ? _projectId : null;

    return AlertDialog(
      title: const Text('Log Payment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int?>(
              isExpanded: true,
              decoration: _dec('Employee'),
              initialValue: empVal,
              items: [
                const DropdownMenuItem<int?>(
                    value: null, child: Text('Select employee…')),
                ...employees.map((e) => DropdownMenuItem<int?>(
                    value: e.id, child: Text(e.name))),
              ],
              onChanged: (v) => setState(() => _employeeId = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: _dec('Amount').copyWith(
                prefixText: '\$ ',
                errorText: _amountError,
              ),
              onChanged: (_) {
                if (_amountError != null) setState(() => _amountError = null);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              isExpanded: true,
              decoration: _dec('Project (optional)'),
              initialValue: projVal,
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('None')),
                ...projects.map((p) => DropdownMenuItem<int?>(
                    value: p.id,
                    child:
                        Text(p.projectName, overflow: TextOverflow.ellipsis))),
              ],
              onChanged: (v) => setState(() => _projectId = v),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: _dec('Date'),
                child: Text(DateFormat('MMM d, yyyy').format(_date)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: false,
              enableSuggestions: false,
              decoration: _dec('Note (optional)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save Payment')),
      ],
    );
  }
}
