import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/client_project_providers.dart';
import '../../providers/database_provider.dart';

/// Add/edit client dialog (shown via `showDialog`). Pass [existing] to edit,
/// or null to add. Matches the old app's AlertDialog-based form, including the
/// activate/deactivate action (deactivation blocked while the client still has
/// active projects).
class ClientForm extends ConsumerStatefulWidget {
  const ClientForm({super.key, this.existing});

  final DbClient? existing;

  @override
  ConsumerState<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends ConsumerState<ClientForm> {
  late final _nameController =
      TextEditingController(text: widget.existing?.name ?? '');
  late final _contactController =
      TextEditingController(text: widget.existing?.contactPerson ?? '');
  late final _phoneController =
      TextEditingController(text: widget.existing?.phoneNumber ?? '');

  bool get _isEditing => widget.existing != null;
  AppDatabase get _db => ref.read(databaseProvider);

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client name is required.')),
      );
      return;
    }
    final contact = _contactController.text.trim().isEmpty
        ? null
        : _contactController.text.trim();
    final phone = _phoneController.text.trim().isEmpty
        ? null
        : _phoneController.text.trim();

    try {
      if (_isEditing) {
        final c = widget.existing!;
        await _db.clientsDao.updateRow(
          ClientsCompanion(
            id: Value(c.id),
            name: Value(name),
            isActive: Value(c.isActive), // preserved; toggled by its own action
            contactPerson: Value(contact),
            phoneNumber: Value(phone),
          ),
        );
      } else {
        await _db.clientsDao.insertRow(
          ClientsCompanion.insert(
            name: name,
            contactPerson: Value(contact),
            phoneNumber: Value(phone),
          ),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('A client named "$name" may already exist.')),
        );
      }
    }
  }

  Future<void> _toggleActive() async {
    final c = widget.existing!;
    await _db.clientsDao.updateRow(
      ClientsCompanion(
        id: Value(c.id),
        name: Value(c.name),
        isActive: Value(c.isActive == 0 ? 1 : 0),
        contactPerson: Value(c.contactPerson),
        phoneNumber: Value(c.phoneNumber),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.existing;
    final isActive = (c?.isActive ?? 1) != 0;
    final projectsA = ref.watch(projectsStreamProvider);
    final projectsReady = projectsA.hasValue;
    final projects = projectsReady ? projectsA.requireValue : const <DbProject>[];
    final hasActiveProjects =
        c != null && projects.any((p) => p.clientId == c.id && p.isCompleted == 0);
    // Don't allow deactivation until the client's projects are known, so we
    // never silently treat a loading/errored list as "no active projects".
    final deactivateDisabled = isActive && (hasActiveProjects || !projectsReady);
    final deactivateTip = !projectsReady
        ? (projectsA.hasError
            ? 'Could not load projects'
            : 'Loading projects…')
        : (hasActiveProjects
            ? 'Complete all projects before deactivating'
            : '');

    return AlertDialog(
      title: Text(_isEditing ? 'Edit Client' : 'Add Client'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Client Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contactController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Contact Person'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (_isEditing)
          Tooltip(
            message: deactivateTip,
            child: TextButton(
              onPressed: deactivateDisabled ? null : _toggleActive,
              child: Text(
                isActive ? 'Deactivate' : 'Activate',
                style: TextStyle(
                  color: deactivateDisabled
                      ? Colors.grey
                      : (isActive ? Colors.red : Colors.green),
                ),
              ),
            ),
          ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
