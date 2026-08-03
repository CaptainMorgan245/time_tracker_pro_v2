import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/billing_calc.dart';
import '../../../../data/local/drift/app_database.dart';
import '../../../providers/database_provider.dart';

/// Quick cost-code creator backing the timer's "No cost codes yet – tap to
/// create" empty state. Requires a name and one of the four real categories
/// (there is no "unclassified" option — every code is classified at creation;
/// `is_billable` is derived from the category). Inserts on save and returns the
/// new id, or null if the user cancelled or the insert failed (e.g. duplicate
/// name — the column is unique). Full management lives in Settings › Cost Codes.
Future<int?> showCostCodeQuickCreateDialog(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();
  return showDialog<int?>(
    context: context,
    builder: (context) {
      String? error;
      String? category;
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Cost Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: const OutlineInputBorder(),
                  errorText: error,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                initialValue: category,
                isExpanded: true,
                hint: const Text('Category (required)'),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final entry in selectableCostCodeCategories.entries)
                    DropdownMenuItem<String?>(
                        value: entry.key, child: Text(entry.value)),
                ],
                onChanged: (v) => setState(() => category = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) {
                  setState(() => error = 'Enter a name');
                  return;
                }
                final chosen = category;
                if (chosen == null) {
                  setState(() => error = 'Choose a category');
                  return;
                }
                try {
                  final id = await ref
                      .read(databaseProvider)
                      .costCodesDao
                      .insertRow(CostCodesCompanion.insert(
                        name: name,
                        isBillable: Value(isBillableForCategory(chosen)),
                        category: Value(chosen),
                      ));
                  if (context.mounted) Navigator.of(context).pop(id);
                } catch (_) {
                  setState(
                      () => error = 'Could not create (name already in use?)');
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      );
    },
  );
}
