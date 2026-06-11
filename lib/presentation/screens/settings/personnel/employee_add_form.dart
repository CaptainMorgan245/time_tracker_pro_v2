import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/drift/app_database.dart';
import '../../../providers/database_provider.dart';

/// Form card for adding a new employee. Picks a role (auto-filling that role's
/// standard rate), then inserts into the `employees` table. The `employees`
/// StreamProvider refreshes the list automatically; [onEmployeeAdded] is an
/// optional hook kept for callers that still want a post-insert callback.
class AddEmployeeForm extends ConsumerStatefulWidget {
  const AddEmployeeForm({
    super.key,
    required this.roles,
    this.onEmployeeAdded,
  });

  final List<DbRole> roles;
  final VoidCallback? onEmployeeAdded;

  @override
  ConsumerState<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends ConsumerState<AddEmployeeForm> {
  final _nameController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  int? _selectedRoleId;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  /// Compact, outlined field style matching the General & Reports tab.
  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      );

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final roleId = _selectedRoleId;
    if (name.isEmpty || roleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and role are required')),
      );
      return;
    }
    final role = widget.roles.firstWhere((r) => r.id == roleId);
    final rate =
        double.tryParse(_hourlyRateController.text) ?? role.standardRate;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(databaseProvider).employeesDao.insertRow(
            EmployeesCompanion.insert(
              name: name,
              titleId: Value(roleId),
              hourlyRate: Value(rate),
            ),
          );
      _nameController.clear();
      _hourlyRateController.clear();
      setState(() => _selectedRoleId = null);
      widget.onEmployeeAdded?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding employee: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add New Employee',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _dec('Employee Name'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _selectedRoleId,
                    decoration: _dec('Role'),
                    items: widget.roles
                        .map((r) => DropdownMenuItem<int>(
                              value: r.id,
                              child: Text(r.name),
                            ))
                        .toList(),
                    onChanged: (id) {
                      if (id == null) return;
                      final role = widget.roles.firstWhere((r) => r.id == id);
                      setState(() {
                        _selectedRoleId = id;
                        _hourlyRateController.text =
                            role.standardRate.toString();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _hourlyRateController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: _dec('Hourly Rate'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add Employee'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
