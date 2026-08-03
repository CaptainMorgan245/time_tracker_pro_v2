import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/billing_calc.dart';
import '../../../data/local/drift/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/reference_data_providers.dart';
import '../../widgets/async_value_view.dart';

/// "Cost Codes" settings tab — manage the cost codes used to classify time and
/// materials. Every code must carry one of the four real [category] values,
/// which drives the analytics Project Financial Summary; `is_billable` (whether
/// it's a selectable Time & Materials invoice line item) is DERIVED from the
/// category so the two can't drift apart — only `Billable` codes are invoiceable.
///
///   - Contract Work — real cost covered by a fixed contract price (not a T&M
///     line item).
///   - Billable      — the T&M-invoiceable work. `is_billable = 1`.
///   - No Charge     — deliberate write-off; tracked, never billed.
///   - Internal      — overhead; excluded from client-facing project financials.
///
/// There is deliberately no "unclassified" option: a category is required at
/// creation. The null/"needs review" state exists only as leftover legacy data
/// (e.g. imported codes), shown here so it can be corrected — never chosen.
class CostCodesTab extends ConsumerStatefulWidget {
  const CostCodesTab({super.key});

  @override
  ConsumerState<CostCodesTab> createState() => _CostCodesTabState();
}

class _CostCodesTabState extends ConsumerState<CostCodesTab> {
  final _nameController = TextEditingController();
  String? _newCategory; // must be chosen before Add is allowed

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    FocusScope.of(context).unfocus();
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _snack('Enter a cost code name.');
      return;
    }
    final category = _newCategory;
    if (category == null) {
      _snack('Choose a category.');
      return;
    }
    try {
      await _db.costCodesDao.insertRow(
        CostCodesCompanion.insert(
          name: name,
          isBillable: Value(isBillableForCategory(category)),
          category: Value(category),
        ),
      );
      _nameController.clear();
      setState(() => _newCategory = null);
    } catch (_) {
      _snack('Cost code "$name" already exists.');
    }
  }

  Future<void> _save(DbCostCode code, String name, String category) async {
    await _db.costCodesDao.updateRow(
      CostCodesCompanion(
        id: Value(code.id),
        name: Value(name),
        isBillable: Value(isBillableForCategory(category)),
        category: Value(category),
      ),
    );
  }

  Future<void> _delete(DbCostCode code) async {
    try {
      await _db.costCodesDao.deleteById(code.id);
    } catch (_) {
      // FK is enforced (no ON DELETE) — a code in use by time entries/materials
      // can't be removed. Surface that rather than failing silently.
      _snack('Can\'t delete "${code.name}" — it\'s in use by existing records.');
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final codesA = ref.watch(costCodesStreamProvider);
    return AsyncValueView<List<DbCostCode>>(
      value: codesA,
      builder: (codes) {
        final sorted = [...codes]
          ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        return Column(
          children: [
            _buildAddForm(),
            const Divider(height: 1),
            Expanded(
              child: sorted.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No cost codes yet. Add one above.'),
                      ),
                    )
                  : ListView.separated(
                      itemCount: sorted.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) => _buildTile(sorted[i]),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              enableSuggestions: false,
              decoration: _dec('Cost Code Name'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: _categoryDropdown(
              _newCategory,
              (v) => setState(() => _newCategory = v),
              hint: 'Category (required)',
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: _add, child: const Text('Add')),
        ],
      ),
    );
  }

  Widget _buildTile(DbCostCode code) {
    final billable = code.isBillable == 1;
    final needsReview = code.category == null ||
        !selectableCostCodeCategories.containsKey(code.category);
    return ListTile(
      leading: Icon(
        needsReview
            ? Icons.warning_amber_outlined
            : (billable ? Icons.receipt_long : Icons.label_outline),
        color: needsReview
            ? Colors.orange.shade800
            : (billable ? Colors.green.shade700 : Colors.blueGrey),
      ),
      title: Text(code.name),
      subtitle: Text(
        costCodeCategoryLabel(code.category) +
            (billable ? ' · T&M line item' : ''),
        style: needsReview
            ? TextStyle(color: Colors.orange.shade800)
            : null,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () => _showEditDialog(code),
      ),
      onTap: () => _showEditDialog(code),
    );
  }

  Future<void> _showEditDialog(DbCostCode code) async {
    final nameController = TextEditingController(text: code.name);
    // Legacy codes may have a null/unrecognised category; start unselected so
    // the user is forced to pick a real one before saving.
    String? category = selectableCostCodeCategories.containsKey(code.category)
        ? code.category
        : null;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Cost Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                enableSuggestions: false,
                decoration: _dec('Cost Code Name'),
              ),
              const SizedBox(height: 16),
              _categoryDropdown(
                category,
                (v) => setDialogState(() => category = v),
                hint: 'Category (required)',
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category == 'billable'
                      ? 'Appears as a Time & Materials invoice line item.'
                      : category == null
                          ? 'Pick a category to classify this code.'
                          : 'Not a T&M line item.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _delete(code);
                if (context.mounted) Navigator.of(context).pop();
              },
              child:
                  const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  _snack('Enter a cost code name.');
                  return;
                }
                final chosen = category;
                if (chosen == null) {
                  _snack('Choose a category.');
                  return;
                }
                await _save(code, name, chosen);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  // ---- shared bits ---------------------------------------------------------

  Widget _categoryDropdown(
    String? value,
    ValueChanged<String?> onChanged, {
    required String hint,
  }) {
    return DropdownButtonFormField<String?>(
      initialValue: value,
      isExpanded: true,
      decoration: _dec('Category'),
      hint: Text(hint),
      items: [
        for (final entry in selectableCostCodeCategories.entries)
          DropdownMenuItem<String?>(value: entry.key, child: Text(entry.value)),
      ],
      onChanged: onChanged,
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      );
}
