import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/client_project_providers.dart';
import '../../providers/database_provider.dart';
import '../../widgets/async_value_view.dart';

/// Add/edit project dialog (shown via `showDialog`). Pass [existing] to edit,
/// or null to add. Matches the old app's AlertDialog form. Completion is a
/// Complete/Re-open action; Delete is offered when editing (FK-guarded).
/// Sub-projects (parentProjectId) are preserved but not edited here.
class ProjectForm extends ConsumerStatefulWidget {
  const ProjectForm({super.key, this.existing});

  final DbProject? existing;

  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  late final _nameController =
      TextEditingController(text: widget.existing?.projectName ?? '');
  late final _streetController =
      TextEditingController(text: widget.existing?.streetAddress ?? '');
  late final _cityController =
      TextEditingController(text: widget.existing?.city ?? '');
  late final _regionController =
      TextEditingController(text: widget.existing?.region ?? '');
  late final _postalController =
      TextEditingController(text: widget.existing?.postalCode ?? '');
  late final _hourlyRateController = TextEditingController(
      text: widget.existing?.billedHourlyRate != null
          ? (widget.existing!.billedHourlyRate! / 100).toStringAsFixed(2)
          : '');
  late final _priceController = TextEditingController(
      text: widget.existing?.projectPrice != null
          ? (widget.existing!.projectPrice! / 100).toStringAsFixed(2)
          : '');
  late final _markupController = TextEditingController(
      text: (widget.existing?.expenseMarkupPercentage ?? 15.0).toString());
  late final _taxController = TextEditingController(
      text: (widget.existing?.taxRate ?? 5.0).toString());

  late int? _clientId = widget.existing?.clientId;
  late String _pricingModel = widget.existing?.pricingModel ?? 'hourly';
  late bool _isInternal = (widget.existing?.isInternal ?? 0) != 0;

  bool get _isEditing => widget.existing != null;
  AppDatabase get _db => ref.read(databaseProvider);

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _postalController.dispose();
    _hourlyRateController.dispose();
    _priceController.dispose();
    _markupController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  String? _trimOrNull(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final clientId = _clientId;
    if (name.isEmpty || clientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project name and client are required.')),
      );
      return;
    }
    final markup = double.tryParse(_markupController.text) ?? 15.0;
    final tax = double.tryParse(_taxController.text) ?? 5.0;
    final hourlyRateDollars = double.tryParse(_hourlyRateController.text);
    final hourlyRate =
        hourlyRateDollars == null ? null : (hourlyRateDollars * 100).round();
    final priceDollars = double.tryParse(_priceController.text);
    final price = priceDollars == null ? null : (priceDollars * 100).round();

    if (_isEditing) {
      final p = widget.existing!;
      await _db.projectsDao.updateRow(
        ProjectsCompanion(
          id: Value(p.id),
          projectName: Value(name),
          clientId: Value(clientId),
          city: Value(_trimOrNull(_cityController)),
          streetAddress: Value(_trimOrNull(_streetController)),
          region: Value(_trimOrNull(_regionController)),
          postalCode: Value(_trimOrNull(_postalController)),
          pricingModel: Value(_pricingModel),
          isCompleted: Value(p.isCompleted), // toggled via Complete/Re-open
          completionDate: Value(p.completionDate),
          isInternal: Value(_isInternal ? 1 : 0),
          billedHourlyRate: Value(hourlyRate),
          projectPrice: Value(price),
          expenseMarkupPercentage: Value(markup),
          taxRate: Value(tax),
          parentProjectId: Value(p.parentProjectId),
        ),
      );
    } else {
      await _db.projectsDao.insertRow(
        ProjectsCompanion.insert(
          projectName: name,
          clientId: clientId,
          city: Value(_trimOrNull(_cityController)),
          streetAddress: Value(_trimOrNull(_streetController)),
          region: Value(_trimOrNull(_regionController)),
          postalCode: Value(_trimOrNull(_postalController)),
          pricingModel: Value(_pricingModel),
          isInternal: Value(_isInternal ? 1 : 0),
          billedHourlyRate: Value(hourlyRate),
          projectPrice: Value(price),
          expenseMarkupPercentage: Value(markup),
          taxRate: Value(tax),
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _toggleCompleted() async {
    final p = widget.existing!;
    final nowCompleted = p.isCompleted == 0;
    await _db.projectsDao.updateRow(
      ProjectsCompanion(
        id: Value(p.id),
        projectName: Value(p.projectName),
        clientId: Value(p.clientId),
        city: Value(p.city),
        streetAddress: Value(p.streetAddress),
        region: Value(p.region),
        postalCode: Value(p.postalCode),
        pricingModel: Value(p.pricingModel),
        isCompleted: Value(nowCompleted ? 1 : 0),
        completionDate:
            Value(nowCompleted ? DateTime.now().toIso8601String() : null),
        isInternal: Value(p.isInternal),
        billedHourlyRate: Value(p.billedHourlyRate),
        projectPrice: Value(p.projectPrice),
        expenseMarkupPercentage: Value(p.expenseMarkupPercentage),
        taxRate: Value(p.taxRate),
        parentProjectId: Value(p.parentProjectId),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    try {
      await _db.projectsDao.deleteById(widget.existing!.id);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Cannot delete a project with time entries or other linked '
                'records. Mark it Completed instead.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsA = ref.watch(clientsStreamProvider);
    final isCompleted = (widget.existing?.isCompleted ?? 0) != 0;

    return AlertDialog(
      title: Text(_isEditing ? 'Edit Project' : 'Add Project'),
      content: SizedBox(
        width: double.maxFinite,
        child: AsyncValueView<List<DbClient>>(
          value: clientsA,
          builder: (clients) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Project Name'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _clientId,
                decoration: const InputDecoration(labelText: 'Client'),
                items: clients
                    .map((c) =>
                        DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (id) => setState(() => _clientId = id),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _pricingModel,
                decoration: const InputDecoration(labelText: 'Pricing Model'),
                items: const [
                  DropdownMenuItem(value: 'hourly', child: Text('Hourly')),
                  DropdownMenuItem(value: 'fixed', child: Text('Fixed Price')),
                ],
                onChanged: (v) => setState(() => _pricingModel = v ?? 'hourly'),
              ),
              const SizedBox(height: 12),
              if (_pricingModel == 'hourly')
                TextField(
                  controller: _hourlyRateController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Billed Hourly Rate', prefixText: '\$'),
                )
              else
                TextField(
                  controller: _priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Fixed Project Price', prefixText: '\$'),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _streetController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Street Address'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _cityController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _regionController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(labelText: 'Province'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _postalController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Postal Code'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _markupController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Expense Markup %'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _taxController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Tax Rate %'),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                title: const Text('Internal project'),
                value: _isInternal,
                onChanged: (v) => setState(() => _isInternal = v),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (_isEditing)
          TextButton(
            onPressed: _toggleCompleted,
            child: Text(
              isCompleted ? 'Re-open' : 'Complete',
              style: TextStyle(
                  color: isCompleted ? Colors.green : Colors.blue),
            ),
          ),
        if (_isEditing)
          TextButton(
            onPressed: _delete,
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
