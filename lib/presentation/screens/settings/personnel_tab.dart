import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/reference_data_providers.dart';
import '../../widgets/app_setting_list_card.dart';
import '../../widgets/async_value_view.dart';
import 'personnel/employee_add_form.dart';
import 'personnel/employee_list.dart';

/// "Personnel" tab, ported from the original app. Manages roles (`roles` table)
/// and employees (`employees` table): add-employee form + employee list on the
/// left, add-role form + roles list on the right. Roles come from
/// [rolesStreamProvider]; the employee list watches its own providers.
class PersonnelTab extends ConsumerStatefulWidget {
  const PersonnelTab({super.key});

  @override
  ConsumerState<PersonnelTab> createState() => _PersonnelTabState();
}

class _PersonnelTabState extends ConsumerState<PersonnelTab> {
  final _roleNameController = TextEditingController();
  final _roleRateController = TextEditingController();

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  void dispose() {
    _roleNameController.dispose();
    _roleRateController.dispose();
    super.dispose();
  }

  // ---- Roles (writes; the stream refreshes the list automatically) ---------

  Future<void> _addRole() async {
    final name = _roleNameController.text.trim();
    if (name.isEmpty) return;
    FocusScope.of(context).unfocus();
    try {
      await _db.rolesDao.insertRow(
        RolesCompanion(
          name: Value(name),
          standardRate: Value(double.tryParse(_roleRateController.text) ?? 0.0),
        ),
      );
      _roleNameController.clear();
      _roleRateController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role "$name" already exists.')),
        );
      }
    }
  }

  Future<void> _updateRole(DbRole role, String name, double rate) async {
    await _db.rolesDao.updateRow(
      RolesCompanion(
        id: Value(role.id),
        name: Value(name),
        standardRate: Value(rate),
      ),
    );
  }

  Future<void> _deleteRole(int id) async {
    try {
      await _db.rolesDao.deleteById(id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Cannot delete a role that is assigned to an employee. '
                'Reassign those employees first.'),
          ),
        );
      }
    }
  }

  Future<void> _showEditRoleDialog(DbRole role) async {
    final nameController = TextEditingController(text: role.name);
    final rateController =
        TextEditingController(text: role.standardRate.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Role Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: rateController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Standard Rate/hr'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteRole(role.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              _updateRole(
                role,
                nameController.text.trim(),
                double.tryParse(rateController.text) ?? 0.0,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildRolesList(List<DbRole> roles) {
    return AppSettingListCard(
      title: 'Roles',
      items: roles
          .map((r) => '${r.name} (\$${r.standardRate.toStringAsFixed(2)} / hr)')
          .toList(),
      onEdit: (index) => _showEditRoleDialog(roles[index]),
    );
  }

  /// Compact, outlined field style matching the General & Reports tab.
  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      );

  Widget _buildAddRoleForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add New Role',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _roleNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _dec('Role Name'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _roleRateController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: _dec('Standard Rate/hr'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: _addRole,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add Role'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rolesA = ref.watch(rolesStreamProvider);
    return AsyncValueView<List<DbRole>>(
      value: rolesA,
      builder: (roles) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(child: AddEmployeeForm(roles: roles)),
                  const SizedBox(width: 16),
                  Flexible(child: _buildAddRoleForm()),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: EmployeeList()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRolesList(roles)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
