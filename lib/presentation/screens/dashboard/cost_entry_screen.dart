import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/client_project_providers.dart';
import '../../providers/cost_entry_providers.dart';
import '../../widgets/async_value_view.dart';
import 'cost_entry/cost_record_form.dart';

/// Cost Entry tab (index 1): a compact inline form to log material/expense
/// costs, above an editable, filterable list of expenses. The form's
/// Client/Project selection (owned here) also filters the list.
class CostEntryScreen extends ConsumerStatefulWidget {
  const CostEntryScreen({super.key});

  @override
  ConsumerState<CostEntryScreen> createState() => _CostEntryScreenState();
}

class _CostEntryScreenState extends ConsumerState<CostEntryScreen> {
  int? _filterClientId;
  int? _filterProjectId;

  int? _companyClientId(List<DbProject> projects) {
    for (final p in projects) {
      if (p.isInternal != 0) return p.clientId;
    }
    return null;
  }

  List<DbMaterial> _filterMaterials(
    List<DbMaterial> materials,
    List<DbProject> projects,
    int? companyClientId,
  ) {
    var records = materials.where((m) => m.isDeleted == 0).toList();

    if (_filterProjectId != null) {
      records = records.where((m) => m.projectId == _filterProjectId).toList();
    } else if (_filterClientId != null) {
      final projectIds = projects
          .where((p) => _filterClientId == companyClientId
              ? p.isInternal != 0
              : p.clientId == _filterClientId)
          .map((p) => p.id)
          .toSet();
      records = records.where((m) => projectIds.contains(m.projectId)).toList();
    }

    records.sort((a, b) => (b.purchaseDate ?? '').compareTo(a.purchaseDate ?? ''));
    return records;
  }

  Future<void> _delete(DbMaterial record) async {
    await ref.read(costEntryActionsProvider.notifier).delete(record.id);
    final s = ref.read(costEntryActionsProvider);
    if (s.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete expense: ${s.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectsA = ref.watch(projectsStreamProvider);
    final materialsA = ref.watch(materialsStreamProvider);

    return SafeArea(
      child: Column(
        children: [
          CostRecordForm(
            clientId: _filterClientId,
            projectId: _filterProjectId,
            onClientChanged: (id) => setState(() {
              _filterClientId = id;
              _filterProjectId = null;
            }),
            onProjectChanged: (id) => setState(() => _filterProjectId = id),
          ),
          const Divider(height: 1),
          Expanded(child: _buildList(projectsA, materialsA)),
        ],
      ),
    );
  }

  Widget _buildList(
    AsyncValue<List<DbProject>> projectsA,
    AsyncValue<List<DbMaterial>> materialsA,
  ) {
    return AsyncValueView<List<DbProject>>(
      value: projectsA,
      builder: (projects) => AsyncValueView<List<DbMaterial>>(
        value: materialsA,
        builder: (materials) => _list(projects, materials),
      ),
    );
  }

  Widget _list(List<DbProject> projects, List<DbMaterial> materials) {
    final companyClientId = _companyClientId(projects);
    final records = _filterMaterials(materials, projects, companyClientId);
    final projectName = {for (final p in projects) p.id: p.projectName};

    if (records.isEmpty) {
      return const Center(child: Text('No expenses to show.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 80),
      itemCount: records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 2),
      itemBuilder: (context, i) {
        final r = records[i];
        final cost = NumberFormat.currency(symbol: '\$').format(r.cost / 100);
        final date = r.purchaseDate != null
            ? DateFormat('MM/dd').format(DateTime.parse(r.purchaseDate!))
            : '--';
        return Card(
          margin: EdgeInsets.zero,
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$date | ${projectName[r.projectId] ?? 'Unknown'} | $cost',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${r.itemName} | ${r.vendorOrSubtrade ?? 'No vendor'}',
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
                  onPressed: () =>
                      ref.read(editingMaterialProvider.notifier).set(r),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      size: 18, color: Colors.red),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(),
                  onPressed: () => _delete(r),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        );
      },
    );
  }
}
