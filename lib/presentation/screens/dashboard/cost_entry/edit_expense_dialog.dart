import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../data/local/drift/app_database.dart';
import '../../../providers/client_project_providers.dart';
import '../../../providers/cost_entry_providers.dart';
import '../../../providers/reference_data_providers.dart'
    show costCodesStreamProvider;
import '../../../widgets/async_value_view.dart';

/// Isolated "Edit Record" dialog for a material/expense. It hosts its OWN form
/// instance ([_EditExpenseForm]) with its own project selection and field state,
/// so editing can never touch the Cost Entry screen's Client/Project list filter.
///
/// The dialog host follows this app's existing add/edit-form-in-a-dialog idiom
/// (see `TimeEntryScreen._openForm`): a constrained [Dialog] with a header row
/// (title + close) above the form — not an `AppBar`. State management mirrors
/// [ManualTimeEntryForm]: dropdown data comes from the reference stream providers
/// via [AsyncValueView]; editable fields are plain local state seeded
/// synchronously in [initState]; the write goes through [costEntryActionsProvider]
/// (no FutureProvider/DAO-Future).
Future<void> showEditExpenseDialog(BuildContext context, DbMaterial record) {
  return showDialog<void>(
    context: context,
    builder: (dialogCtx) => Dialog(
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
                  const Text(
                    'Edit Record',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(dialogCtx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _EditExpenseForm(
                record: record,
                onSaved: () => Navigator.of(dialogCtx).pop(),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _EditExpenseForm extends ConsumerStatefulWidget {
  const _EditExpenseForm({required this.record, required this.onSaved});

  final DbMaterial record;

  /// Called after a successful update so the host dialog can close.
  final VoidCallback onSaved;

  @override
  ConsumerState<_EditExpenseForm> createState() => _EditExpenseFormState();
}

class _EditExpenseFormState extends ConsumerState<_EditExpenseForm> {
  final _itemNameController = TextEditingController();
  final _costController = TextEditingController();
  final _quantityController = TextEditingController();
  final _odometerController = TextEditingController();

  // Owned entirely by the dialog — never the screen filter.
  late int? _projectId;
  late DateTime _purchaseDate;
  String? _category;
  String? _vendor;
  String? _vehicleDesignation;
  int? _costCodeId;
  bool _isCompanyExpense = false;
  bool _isReturn = false;

  bool get _isFuel => _category == 'Fuel';

  @override
  void initState() {
    super.initState();
    // Seed editable fields synchronously from the row being edited (local state
    // is safe to set here — no provider mutation, no post-frame indirection).
    final e = widget.record;
    _projectId = e.projectId;
    _itemNameController.text = e.itemName;
    _costController.text = (e.cost.abs() / 100).toStringAsFixed(2);
    _quantityController.text = e.quantity?.toStringAsFixed(2) ?? '';
    _odometerController.text = e.odometerReading?.toStringAsFixed(0) ?? '';
    _purchaseDate =
        e.purchaseDate != null ? DateTime.parse(e.purchaseDate!) : DateTime.now();
    _category = e.expenseCategory;
    _vendor = e.vendorOrSubtrade;
    _vehicleDesignation = e.vehicleDesignation;
    _costCodeId = e.costCodeId;
    _isCompanyExpense = e.isCompanyExpense != 0;
    _isReturn = e.cost < 0;
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _costController.dispose();
    _quantityController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  static InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      );

  // Explicit color: a bare TextStyle(fontSize: 13) with no color renders
  // invisible against the dialog surface (same issue seen in the other forms).
  static const _fieldStyle = TextStyle(fontSize: 13, color: Colors.black87);

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  int? _internalProjectId(List<DbProject> projects) {
    for (final p in projects) {
      if (p.isInternal != 0) return p.id;
    }
    return null;
  }

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
        _isCompanyExpense ? _internalProjectId(projects) : _projectId;
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
    final signedDollars = _isReturn ? -raw.abs() : raw.abs();
    final signed = (signedDollars * 100).round();
    final itemName = _itemNameController.text.trim().isEmpty
        ? 'General Expense'
        : _itemNameController.text.trim();
    final qty =
        _isCompanyExpense ? double.tryParse(_quantityController.text) : null;
    final odo =
        _isCompanyExpense ? double.tryParse(_odometerController.text) : null;

    await ref.read(costEntryActionsProvider.notifier).update(
          widget.record.toCompanion(false).copyWith(
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
    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final projectsA = ref.watch(projectsStreamProvider);
    final categoriesA = ref.watch(expenseCategoriesStreamProvider);
    final costCodesA = ref.watch(costCodesStreamProvider);
    final settingsA = ref.watch(appSettingsStreamProvider);
    final busy = ref.watch(costEntryActionsProvider).isLoading;

    return AsyncValueView<List<DbProject>>(
      value: projectsA,
      builder: (projects) => AsyncValueView<List<DbExpenseCategory>>(
        value: categoriesA,
        builder: (categoryRows) => AsyncValueView<List<DbCostCode>>(
          value: costCodesA,
          builder: (costCodes) => AsyncValueView<DbSetting?>(
            value: settingsA,
            builder: (settings) => _form(
              projects,
              categoryRows.map((c) => c.name).toList(),
              costCodes,
              splitCsv(settings?.vendors),
              splitCsv(settings?.vehicleDesignations),
              busy,
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(
    List<DbProject> projects,
    List<String> categories,
    List<DbCostCode> costCodes,
    List<String> vendors,
    List<String> vehicles,
    bool busy,
  ) {
    // Editing is scoped to a single Project dropdown over all projects (v1's
    // edit dialog behaviour) — no Client filter, so nothing here can affect the
    // screen's list filter.
    final projectOptions = {for (final p in projects) p.id: p}.values.toList();
    final projectValue =
        projectOptions.any((p) => p.id == _projectId) ? _projectId : null;
    final categoryValue = categories.contains(_category) ? _category : null;
    final vendorValue = vendors.contains(_vendor) ? _vendor : null;
    final vehicleValue =
        vehicles.contains(_vehicleDesignation) ? _vehicleDesignation : null;
    final costCodeValue =
        costCodes.any((c) => c.id == _costCodeId) ? _costCodeId : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: Project | Item Name | Category
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: _isCompanyExpense ? null : projectValue,
                isExpanded: true,
                isDense: true,
                style: _fieldStyle,
                decoration:
                    _dec(_isCompanyExpense ? 'Project (Internal)' : 'Project *'),
                items: _isCompanyExpense
                    ? const [
                        DropdownMenuItem<int>(
                            value: null,
                            child: Text('Internal Company Project'))
                      ]
                    : [
                        const DropdownMenuItem<int>(
                            value: null, child: Text('-- Select Project --')),
                        ...projectOptions.map((p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.projectName,
                                  overflow: TextOverflow.ellipsis),
                            )),
                      ],
                onChanged: _isCompanyExpense
                    ? null
                    : (id) => setState(() => _projectId = id),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _itemNameController,
                style: _fieldStyle,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec('Item Name'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: categoryValue,
                isExpanded: true,
                isDense: true,
                style: _fieldStyle,
                decoration: _dec('Category *'),
                items: categories
                    .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Row 2: Vehicle checkbox
        Row(
          children: [
            const Text('Vehicle Expense',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Checkbox(
              value: _isCompanyExpense,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (v) => setState(() => _isCompanyExpense = v ?? false),
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
                        child: Text(v, overflow: TextOverflow.ellipsis)))
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
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (v) => setState(() => _isReturn = v ?? false),
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
                  const DropdownMenuItem<int>(value: null, child: Text('None')),
                  ...costCodes.map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name, overflow: TextOverflow.ellipsis))),
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
                          child: Text(v, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (v) => setState(() => _vehicleDesignation = v),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  style: _fieldStyle,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: busy ? null : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10)),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: FilledButton(
                onPressed: busy ? null : () => _submit(projects),
                style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10)),
                child: const Text('Update Expense'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
