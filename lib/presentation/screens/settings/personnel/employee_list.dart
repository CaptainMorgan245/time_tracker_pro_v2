import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/local/drift/app_database.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/reference_data_providers.dart';
import '../../../widgets/async_value_view.dart';

/// Single card listing employees (active, then inactive). Watches the employees
/// and roles StreamProviders directly. Tapping an employee opens an edit dialog
/// to change name/role/rate or toggle active state (soft-delete via
/// `isDeleted`); writes go through the employees DAO and the stream refreshes.
class EmployeeList extends ConsumerStatefulWidget {
  const EmployeeList({super.key});

  @override
  ConsumerState<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends ConsumerState<EmployeeList> {
  String _roleName(int? titleId, List<DbRole> roles) {
    if (titleId == null) return 'N/A';
    for (final r in roles) {
      if (r.id == titleId) return r.name;
    }
    return 'N/A';
  }

  Future<void> _update(EmployeesCompanion entry) async {
    await ref.read(databaseProvider).employeesDao.updateRow(entry);
  }

  Future<void> _showEditDialog(DbEmployee employee, List<DbRole> roles) async {
    final nameController = TextEditingController(text: employee.name);
    final hourlyRateController =
        TextEditingController(text: employee.hourlyRate?.toString() ?? '');
    int? selectedRoleId = employee.titleId;
    final isDeleted = employee.isDeleted != 0;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Employee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Employee Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(
                  text: employee.employeeNumber ?? 'Not Assigned'),
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Employee Number'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int?>(
              initialValue: selectedRoleId,
              decoration: const InputDecoration(labelText: 'Select Role'),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('No Role')),
                ...roles.map((r) => DropdownMenuItem<int?>(
                      value: r.id,
                      child: Text(r.name),
                    )),
              ],
              onChanged: (value) => selectedRoleId = value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: hourlyRateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Hourly Rate'),
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
              // Toggle active state; all other fields unchanged.
              _update(EmployeesCompanion(
                id: Value(employee.id),
                employeeNumber: Value(employee.employeeNumber),
                name: Value(employee.name),
                titleId: Value(employee.titleId),
                hourlyRate: Value(employee.hourlyRate),
                isDeleted: Value(isDeleted ? 0 : 1),
              ));
              Navigator.of(context).pop();
            },
            child: Text(
              isDeleted ? 'Activate' : 'Deactivate',
              style: TextStyle(color: isDeleted ? Colors.green : Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              _update(EmployeesCompanion(
                id: Value(employee.id),
                employeeNumber: Value(employee.employeeNumber),
                name: Value(nameController.text.trim()),
                titleId: Value(selectedRoleId),
                hourlyRate: Value(double.tryParse(hourlyRateController.text)),
                isDeleted: Value(employee.isDeleted),
              ));
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(List<DbEmployee> list, List<DbRole> roles, Color color,
      {bool inactive = false}) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (inactive)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text('Inactive Employees',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red.shade700)),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final e = list[index];
            return InkWell(
              onTap: () => _showEditDialog(e, roles),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 2, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontStyle: inactive
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                              color: color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Role: ${_roleName(e.titleId, roles)} | Number: ${e.employeeNumber ?? 'N/A'}',
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
                      onPressed: () => _showEditDialog(e, roles),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeesA = ref.watch(employeesStreamProvider);
    final rolesA = ref.watch(rolesStreamProvider);

    return Card(
      margin: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AsyncValueView<List<DbEmployee>>(
            value: employeesA,
            builder: (employees) => AsyncValueView<List<DbRole>>(
              value: rolesA,
              builder: (roles) => _content(employees, roles),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(List<DbEmployee> employees, List<DbRole> roles) {
    final active = employees.where((e) => e.isDeleted == 0).toList();
    final inactive = employees.where((e) => e.isDeleted != 0).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (active.isEmpty && inactive.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No employees yet'),
          ),
        _buildSection(active, roles, Colors.black),
        if (inactive.isNotEmpty) ...[
          const Divider(),
          _buildSection(inactive, roles, Colors.grey, inactive: true),
        ],
      ],
    );
  }
}
