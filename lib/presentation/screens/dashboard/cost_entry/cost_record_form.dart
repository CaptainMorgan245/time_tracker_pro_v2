import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../data/local/drift/app_database.dart';
import '../../../providers/client_project_providers.dart';
import '../../../providers/cost_entry_providers.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/reference_data_providers.dart'
    show costCodesStreamProvider;
import '../../../widgets/async_value_view.dart';

/// Compact inline add/edit form for an expense, ported from the original app's
/// CostRecordFormTopRow + CostRecordForm. Deliberately dense: small outlined
/// boxes packed across rows so the list below keeps its space.
///
/// Client/Project are owned by the screen (they also filter the list) and
/// passed in. When the list's Edit icon sets [editingMaterialProvider], the
/// form populates and syncs the Client/Project filter to that record.
class CostRecordForm extends ConsumerStatefulWidget {
  const CostRecordForm({
    super.key,
    required this.clientId,
    required this.projectId,
    required this.onClientChanged,
    required this.onProjectChanged,
  });

  final int? clientId;
  final int? projectId;
  final ValueChanged<int?> onClientChanged;
  final ValueChanged<int?> onProjectChanged;

  @override
  ConsumerState<CostRecordForm> createState() => _CostRecordFormState();
}

class _CostRecordFormState extends ConsumerState<CostRecordForm> {
  final _itemNameController = TextEditingController();
  final _costController = TextEditingController();
  final _quantityController = TextEditingController();
  final _odometerController = TextEditingController();

  int? _editingId;
  DateTime _purchaseDate = DateTime.now();
  String? _category;
  String? _vendor;
  String? _vehicleDesignation;
  int? _costCodeId;
  bool _isCompanyExpense = false;
  bool _isReturn = false;

  bool get _isEditing => _editingId != null;
  bool get _isFuel => _category == 'Fuel';

  @override
  void dispose() {
    _itemNameController.dispose();
    _costController.dispose();
    _quantityController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  static InputDecoration _dec(String label, {Widget? suffixIcon}) =>
      InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        suffixIcon: suffixIcon,
      );

  static const _fieldStyle = TextStyle(fontSize: 13);

  int? _internalProjectId(List<DbProject> projects) {
    for (final p in projects) {
      if (p.isInternal != 0) return p.id;
    }
    return null;
  }

  void _populateFrom(DbMaterial e) {
    final projects =
        ref.read(projectsStreamProvider).asData?.value ?? const <DbProject>[];
    int? clientId;
    for (final p in projects) {
      if (p.id == e.projectId) {
        clientId = p.clientId;
        break;
      }
    }
    setState(() {
      _editingId = e.id;
      _itemNameController.text = e.itemName;
      _costController.text = e.cost.abs().toStringAsFixed(2);
      _quantityController.text = e.quantity?.toStringAsFixed(2) ?? '';
      _odometerController.text = e.odometerReading?.toStringAsFixed(0) ?? '';
      _purchaseDate = e.purchaseDate != null
          ? DateTime.parse(e.purchaseDate!)
          : DateTime.now();
      _category = e.expenseCategory;
      _vendor = e.vendorOrSubtrade;
      _vehicleDesignation = e.vehicleDesignation;
      _costCodeId = e.costCodeId;
      _isCompanyExpense = e.isCompanyExpense != 0;
      _isReturn = e.cost < 0;
    });
    widget.onClientChanged(clientId);
    widget.onProjectChanged(e.projectId);
  }

  void _reset() {
    _itemNameController.clear();
    _costController.clear();
    _quantityController.clear();
    _odometerController.clear();
    setState(() {
      _editingId = null;
      _purchaseDate = DateTime.now();
      _category = null;
      _vendor = null;
      _vehicleDesignation = null;
      _costCodeId = null;
      _isCompanyExpense = false;
      _isReturn = false;
    });
  }

  void _clear() {
    ref.read(editingMaterialProvider.notifier).set(null);
    _reset();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _purchaseDate = picked);
  }

  Future<void> _submit(List<DbProject> projects) async {
    FocusScope.of(context).unfocus();
    final projectId =
        _isCompanyExpense ? _internalProjectId(projects) : widget.projectId;
    if (projectId == null) {
      _snack(_isCompanyExpense
          ? 'No internal company project exists to file this under.'
          : 'Please select a project.');
      return;
    }
    if (_category == null) {
      _snack('Please select an expense category.');
      return;
    }
    final raw = double.tryParse(_costController.text);
    if (raw == null) {
      _snack('Enter a valid cost.');
      return;
    }
    final signed = _isReturn ? -raw.abs() : raw.abs();
    final itemName = _itemNameController.text.trim().isEmpty
        ? 'General Expense'
        : _itemNameController.text.trim();
    final qty =
        _isCompanyExpense ? double.tryParse(_quantityController.text) : null;
    final odo =
        _isCompanyExpense ? double.tryParse(_odometerController.text) : null;

    final actions = ref.read(costEntryActionsProvider.notifier);
    if (_isEditing) {
      final existing =
          await ref.read(databaseProvider).materialsDao.getById(_editingId!);
      if (existing == null) {
        _clear();
        return;
      }
      await actions.update(
        existing.toCompanion(false).copyWith(
              projectId: Value(projectId),
              itemName: Value(itemName),
              cost: Value(signed),
              purchaseDate: Value(_purchaseDate.toIso8601String()),
              expenseCategory: Value(_category),
              isCompanyExpense: Value(_isCompanyExpense ? 1 : 0),
              vehicleDesignation:
                  Value(_isCompanyExpense ? _vehicleDesignation : null),
              vendorOrSubtrade: Value(_vendor),
              costCodeId: Value(_costCodeId),
              unit: Value(_isFuel ? 'Liters' : null),
              quantity: Value(qty),
              odometerReading: Value(odo),
            ),
      );
      if (!mounted) return;
      final s = ref.read(costEntryActionsProvider);
      if (s.hasError) {
        _snack('Failed to save expense: ${s.error}');
        return;
      }
      ref.read(editingMaterialProvider.notifier).set(null);
      _reset();
    } else {
      await actions.add(
        MaterialsCompanion.insert(
          projectId: projectId,
          itemName: itemName,
          cost: signed,
          purchaseDate: Value(_purchaseDate.toIso8601String()),
          expenseCategory: Value(_category),
          isCompanyExpense: Value(_isCompanyExpense ? 1 : 0),
          vehicleDesignation:
              Value(_isCompanyExpense ? _vehicleDesignation : null),
          vendorOrSubtrade: Value(_vendor),
          costCodeId: Value(_costCodeId),
          unit: Value(_isFuel ? 'Liters' : null),
          quantity: Value(qty),
          odometerReading: Value(odo),
        ),
      );
      if (!mounted) return;
      final s = ref.read(costEntryActionsProvider);
      if (s.hasError) {
        _snack('Failed to save expense: ${s.error}');
        return;
      }
      _reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<DbMaterial?>(editingMaterialProvider, (prev, next) {
      if (next != null && next.id != _editingId) {
        _populateFrom(next);
      } else if (next == null && _editingId != null) {
        _reset();
      }
    });

    final projectsA = ref.watch(projectsStreamProvider);
    final clientsA = ref.watch(clientsStreamProvider);
    final categoriesA = ref.watch(expenseCategoriesStreamProvider);
    final costCodesA = ref.watch(costCodesStreamProvider);
    final settingsA = ref.watch(appSettingsStreamProvider);
    final busy = ref.watch(costEntryActionsProvider).isLoading;
    return AsyncValueView<List<DbProject>>(
      value: projectsA,
      builder: (projects) => AsyncValueView<List<DbClient>>(
        value: clientsA,
        builder: (clients) => AsyncValueView<List<DbExpenseCategory>>(
          value: categoriesA,
          builder: (categoryRows) => AsyncValueView<List<DbCostCode>>(
            value: costCodesA,
            builder: (costCodes) => AsyncValueView<DbSetting?>(
              value: settingsA,
              builder: (settings) => _form(
                projects,
                clients,
                categoryRows.map((c) => c.name).toList(),
                costCodes,
                splitCsv(settings?.vendors),
                splitCsv(settings?.vehicleDesignations),
                busy,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(
    List<DbProject> projects,
    List<DbClient> clients,
    List<String> categories,
    List<DbCostCode> costCodes,
    List<String> vendors,
    List<String> vehicles,
    bool busy,
  ) {
    final companyClientId = _companyClientId(projects);
    final projectOptions = _projectOptions(projects, companyClientId);

    final clientValue =
        clients.any((c) => c.id == widget.clientId) ? widget.clientId : null;
    final projectValue =
        projectOptions.any((p) => p.id == widget.projectId) ? widget.projectId : null;
    final categoryValue = categories.contains(_category) ? _category : null;
    final vendorValue = vendors.contains(_vendor) ? _vendor : null;
    final vehicleValue =
        vehicles.contains(_vehicleDesignation) ? _vehicleDesignation : null;
    final costCodeValue =
        costCodes.any((c) => c.id == _costCodeId) ? _costCodeId : null;

    return Card(
      margin: const EdgeInsets.fromLTRB(6, 6, 6, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
        child: Column(
          children: [
            // Row 1: Client | Project
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: clientValue,
                    isExpanded: true,
                    isDense: true,
                    style: _fieldStyle,
                    decoration: _dec('Client'),
                    items: [
                      const DropdownMenuItem<int>(
                          value: null, child: Text('All Clients')),
                      ...clients
                          .where((c) => c.isActive != 0)
                          .map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name,
                                    overflow: TextOverflow.ellipsis),
                              )),
                    ],
                    onChanged: widget.onClientChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _isCompanyExpense ? null : projectValue,
                    isExpanded: true,
                    isDense: true,
                    style: _fieldStyle,
                    decoration: _dec(_isCompanyExpense ? 'Project (Internal)' : 'Project *'),
                    items: _isCompanyExpense
                        ? const [
                            DropdownMenuItem<int>(
                                value: null,
                                child: Text('Internal Company Project'))
                          ]
                        : [
                            const DropdownMenuItem<int>(
                                value: null, child: Text('All Projects')),
                            ...projectOptions.map((p) => DropdownMenuItem(
                                  value: p.id,
                                  child: Text(p.projectName,
                                      overflow: TextOverflow.ellipsis),
                                )),
                          ],
                    onChanged:
                        _isCompanyExpense ? null : widget.onProjectChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row 2: Item Name | Category | Vehicle checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: _itemNameController,
                    style: _fieldStyle,
                    textCapitalization: TextCapitalization.words,
                    decoration: _dec('Item Name'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: DropdownButtonFormField<String>(
                    initialValue: categoryValue,
                    isExpanded: true,
                    isDense: true,
                    style: _fieldStyle,
                    decoration: _dec('Category *'),
                    items: categories
                        .map((c) => DropdownMenuItem(
                            value: c,
                            child:
                                Text(c, overflow: TextOverflow.ellipsis)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v),
                  ),
                ),
                const SizedBox(width: 4),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Vehicle',
                        style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _isCompanyExpense,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        onChanged: (v) =>
                            setState(() => _isCompanyExpense = v ?? false),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row 3: Vendor | Date | Cost | Return | Cost Code
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    initialValue: vendorValue,
                    isExpanded: true,
                    isDense: true,
                    style: _fieldStyle,
                    decoration: _dec('Vendor'),
                    items: vendors
                        .map((v) => DropdownMenuItem(
                            value: v,
                            child:
                                Text(v, overflow: TextOverflow.ellipsis)))
                        .toList(),
                    onChanged: (v) => setState(() => _vendor = v),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: _dec('Date *'),
                      child: Text(DateFormat('MMM dd').format(_purchaseDate),
                          style: _fieldStyle),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _costController,
                    style: _fieldStyle,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: _dec('Cost *'),
                  ),
                ),
                const SizedBox(width: 2),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Return', style: TextStyle(fontSize: 9)),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _isReturn,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        onChanged: (v) =>
                            setState(() => _isReturn = v ?? false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<int>(
                    initialValue: costCodeValue,
                    isExpanded: true,
                    isDense: true,
                    style: _fieldStyle,
                    decoration: _dec('Cost Code'),
                    items: [
                      const DropdownMenuItem<int>(
                          value: null, child: Text('None')),
                      ...costCodes.map((c) => DropdownMenuItem(
                          value: c.id,
                          child:
                              Text(c.name, overflow: TextOverflow.ellipsis))),
                    ],
                    onChanged: (id) => setState(() => _costCodeId = id),
                  ),
                ),
              ],
            ),
            // Row 4 (vehicle only): Designation | Quantity | Odometer
            if (_isCompanyExpense) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: vehicleValue,
                      isExpanded: true,
                      isDense: true,
                      style: _fieldStyle,
                      decoration: _dec('Vehicle'),
                      items: vehicles
                          .map((v) => DropdownMenuItem(
                              value: v,
                              child:
                                  Text(v, overflow: TextOverflow.ellipsis)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _vehicleDesignation = v),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      style: _fieldStyle,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: _dec(_isFuel ? 'Qty (L)' : 'Qty'),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _odometerController,
                      style: _fieldStyle,
                      keyboardType: TextInputType.number,
                      decoration: _dec('Odometer'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: busy ? null : _clear,
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10)),
                    child: Text(_isEditing ? 'Cancel' : 'Clear'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: FilledButton(
                    onPressed: busy ? null : () => _submit(projects),
                    style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10)),
                    child: Text(_isEditing ? 'Update Expense' : 'Add Expense'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int? _companyClientId(List<DbProject> projects) {
    for (final p in projects) {
      if (p.isInternal != 0) return p.clientId;
    }
    return null;
  }

  /// Project options for the dropdown, scoped to the selected client.
  List<DbProject> _projectOptions(
      List<DbProject> projects, int? companyClientId) {
    if (widget.clientId != null && widget.clientId == companyClientId) {
      return projects.where((p) => p.isInternal != 0).toList();
    }
    if (widget.clientId != null) {
      return projects
          .where((p) => p.clientId == widget.clientId && p.isCompleted == 0)
          .toList();
    }
    return projects
        .where((p) => p.isCompleted == 0 && p.isInternal == 0)
        .toList();
  }
}
