import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/cost_entry_providers.dart';
import '../../providers/database_provider.dart';
import '../../widgets/app_setting_list_card.dart';
import '../../widgets/async_value_view.dart';

/// "Expenses" tab, ported from the original app. Manages three lists, all read
/// reactively:
///   - Expense Categories — [expenseCategoriesStreamProvider]
///   - Vehicle Designations — comma-joined on `settings.vehicleDesignations`
///   - Vendors / Subtrades — comma-joined on `settings.vendors`
/// (both via [appSettingsStreamProvider] + [splitCsv]).
class ExpensesTab extends ConsumerStatefulWidget {
  const ExpensesTab({super.key});

  @override
  ConsumerState<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends ConsumerState<ExpensesTab> {
  final _categoryController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _vendorController = TextEditingController();

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  void dispose() {
    _categoryController.dispose();
    _vehicleController.dispose();
    _vendorController.dispose();
    super.dispose();
  }

  // ---- Expense categories (own table; stream refreshes the list) -----------

  Future<void> _addCategory() async {
    FocusScope.of(context).unfocus();
    final name = _categoryController.text.trim();
    if (name.isEmpty) return;
    try {
      await _db.expenseCategoriesDao
          .insertRow(ExpenseCategoriesCompanion(name: Value(name)));
      _categoryController.clear();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category "$name" already exists.')),
        );
      }
    }
  }

  Future<void> _updateCategory(DbExpenseCategory category, String name) async {
    await _db.expenseCategoriesDao.updateRow(
      ExpenseCategoriesCompanion(id: Value(category.id), name: Value(name)),
    );
  }

  Future<void> _deleteCategory(int id) async {
    await _db.expenseCategoriesDao.deleteById(id);
  }

  // ---- Vehicles / vendors (comma-joined on settings; settings stream
  //      refreshes) -----------------------------------------------------------

  Future<void> _saveLists(List<String> vehicles, List<String> vendors) async {
    await _db.settingsDao.saveSettings(
      SettingsCompanion(
        vehicleDesignations: Value(vehicles.join(',')),
        vendors: Value(vendors.join(',')),
      ),
    );
  }

  void _addVehicle(List<String> vehicles, List<String> vendors) {
    FocusScope.of(context).unfocus();
    final name = _vehicleController.text.trim();
    if (name.isEmpty) return;
    _vehicleController.clear();
    _saveLists([...vehicles, name], vendors);
  }

  void _addVendor(List<String> vehicles, List<String> vendors) {
    FocusScope.of(context).unfocus();
    final name = _vendorController.text.trim();
    if (name.isEmpty) return;
    _vendorController.clear();
    _saveLists(vehicles, [...vendors, name]);
  }

  // ---- Dialogs / form helpers ----------------------------------------------

  void _showEditDialog(
    String title,
    String currentValue,
    void Function(String) onSave,
    VoidCallback onDelete,
  ) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Compact, outlined field style matching the General & Reports tab.
  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      );

  Widget _buildForm(
      String label, TextEditingController controller, VoidCallback onAdd) {
    final applyCapitalization = label != 'Vehicle Designation';
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                textCapitalization: applyCapitalization
                    ? TextCapitalization.words
                    : TextCapitalization.none,
                decoration: _dec(label),
              ),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: onAdd, child: const Text('Add')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesA = ref.watch(expenseCategoriesStreamProvider);
    final settingsA = ref.watch(appSettingsStreamProvider);
    return AsyncValueView<List<DbExpenseCategory>>(
      value: categoriesA,
      builder: (categories) => AsyncValueView<DbSetting?>(
        value: settingsA,
        builder: (settings) => _content(
          categories,
          splitCsv(settings?.vehicleDesignations),
          splitCsv(settings?.vendors),
        ),
      ),
    );
  }

  Widget _content(
    List<DbExpenseCategory> categories,
    List<String> vehicles,
    List<String> vendors,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildForm('Expense Category', _categoryController, _addCategory),
                const SizedBox(width: 16),
                _buildForm('Vehicle Designation', _vehicleController,
                    () => _addVehicle(vehicles, vendors)),
                const SizedBox(width: 16),
                _buildForm('Vendor / Subtrade', _vendorController,
                    () => _addVendor(vehicles, vendors)),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: AppSettingListCard(
                    title: 'Expense Categories',
                    items: categories.map((c) => c.name).toList(),
                    onEdit: (index) {
                      final category = categories[index];
                      _showEditDialog(
                        'Expense Category',
                        category.name,
                        (newValue) => _updateCategory(category, newValue),
                        () => _deleteCategory(category.id),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: AppSettingListCard(
                    title: 'Vehicle Designations',
                    items: vehicles,
                    onEdit: (index) => _showEditDialog(
                      'Vehicle Designation',
                      vehicles[index],
                      (newValue) => _saveLists(
                          [...vehicles]..[index] = newValue, vendors),
                      () => _saveLists([...vehicles]..removeAt(index), vendors),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: AppSettingListCard(
                    title: 'Vendors / Subtrades',
                    items: vendors,
                    onEdit: (index) => _showEditDialog(
                      'Vendor / Subtrade',
                      vendors[index],
                      (newValue) => _saveLists(
                          vehicles, [...vendors]..[index] = newValue),
                      () => _saveLists(vehicles, [...vendors]..removeAt(index)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
