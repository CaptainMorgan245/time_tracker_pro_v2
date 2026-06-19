import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/local/drift/app_database.dart';
import '../providers/database_provider.dart';

/// Developer tool for inspecting the live Drift database.
///
/// Faithful port of the original app's viewer:
///  - **Records list** (main screen) — all time entries + material/expense
///    records, with Show (all/time/expenses) and Sort (date oldest / id newest)
///    filters, shown as compact cards. Delete removes a record.
///  - **SQL runner** (toolbar) — execute arbitrary SQL (SELECT/PRAGMA → grid,
///    others → run).
///  - **Schema viewer** (toolbar) — dump every table's `CREATE TABLE`.
class DatabaseViewerScreen extends ConsumerStatefulWidget {
  const DatabaseViewerScreen({super.key});

  @override
  ConsumerState<DatabaseViewerScreen> createState() =>
      _DatabaseViewerScreenState();
}

class _DatabaseViewerScreenState extends ConsumerState<DatabaseViewerScreen> {
  String _recordFilter = 'all'; // all | time | expense
  String _sortBy = 'date_asc'; // date_asc | id_desc
  int _refreshKey = 0;

  final TextEditingController _sqlController = TextEditingController();
  List<Map<String, dynamic>>? _queryResults;
  String? _queryError;
  String? _mutationResult;

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  void dispose() {
    _sqlController.dispose();
    super.dispose();
  }

  // ---- Records list --------------------------------------------------------

  /// Combined time + material records, mirroring the original `getAllRecordsV2`
  /// (joins to project/client; only non-deleted rows with a date).
  Future<List<_RecordRow>> _loadRecords() async {
    final records = <_RecordRow>[];

    final timeRows = await _db.customSelect('''
      SELECT t.id, t.start_time, t.work_details, t.final_billed_duration_seconds,
             p.project_name, c.name AS client_name
      FROM time_entries t
      JOIN projects p ON t.project_id = p.id
      JOIN clients c ON p.client_id = c.id
      WHERE t.is_deleted = 0 AND t.start_time IS NOT NULL
    ''').get();
    for (final row in timeRows) {
      final d = row.data;
      records.add(_RecordRow(
        id: d['id'] as int,
        isTime: true,
        date: DateTime.parse(d['start_time'] as String),
        description: d['work_details'] as String? ?? 'No Details',
        value: (d['final_billed_duration_seconds'] as num? ?? 0.0) / 3600.0,
        categoryOrProject:
            '${d['client_name'] as String? ?? 'Unknown Client'} - '
            '${d['project_name'] as String? ?? 'Unknown Project'}',
      ));
    }

    final matRows = await _db.customSelect('''
      SELECT m.id, m.purchase_date, m.item_name, m.cost, m.expense_category,
             p.project_name
      FROM materials m
      JOIN projects p ON m.project_id = p.id
      WHERE m.is_deleted = 0 AND m.purchase_date IS NOT NULL
    ''').get();
    for (final row in matRows) {
      final d = row.data;
      records.add(_RecordRow(
        id: d['id'] as int,
        isTime: false,
        date: DateTime.parse(d['purchase_date'] as String),
        description: d['item_name'] as String? ?? 'Unnamed Item',
        value: (d['cost'] as num? ?? 0).toDouble() / 100,
        categoryOrProject: d['expense_category'] as String? ??
            d['project_name'] as String? ??
            'Uncategorized',
      ));
    }

    return records;
  }

  List<_RecordRow> _filterAndSort(List<_RecordRow> records) {
    List<_RecordRow> list;
    if (_recordFilter == 'time') {
      list = records.where((r) => r.isTime).toList();
    } else if (_recordFilter == 'expense') {
      list = records.where((r) => !r.isTime).toList();
    } else {
      list = [...records];
    }

    switch (_sortBy) {
      case 'date_asc':
        list.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'id_desc':
        list.sort((a, b) => b.id.compareTo(a.id));
        break;
    }
    return list;
  }

  // ---- SQL query runner ----------------------------------------------------

  Future<void> _executeQuery() async {
    final query = _sqlController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _queryError = 'Please enter a SQL query';
        _queryResults = null;
        _mutationResult = null;
      });
      return;
    }

    final upper = query.toUpperCase();
    final isSelect = upper.startsWith('SELECT') || upper.startsWith('PRAGMA');

    try {
      if (isSelect) {
        final rows = await _db.customSelect(query).get();
        setState(() {
          _queryResults = rows.map((r) => r.data).toList();
          _queryError = null;
          _mutationResult = null;
        });
      } else {
        await _db.customStatement(query);
        setState(() {
          _queryResults = null;
          _queryError = null;
          _mutationResult = 'Statement executed successfully.';
          _refreshKey++; // records list may now be stale
        });
      }
    } catch (e) {
      setState(() {
        _queryError = e.toString();
        _queryResults = null;
        _mutationResult = null;
      });
    }
  }

  void _showQueryRunner() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SQL Query Runner',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _sqlController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText:
                          'SELECT * FROM time_entries ORDER BY id DESC LIMIT 10',
                      labelText: 'SQL Query (any statement)',
                    ),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text('Quick: ',
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey)),
                        _pragmaChip('Tables',
                            "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"),
                        _pragmaChip('clients', 'PRAGMA table_info(clients)'),
                        _pragmaChip('projects', 'PRAGMA table_info(projects)'),
                        _pragmaChip(
                            'time_entries', 'PRAGMA table_info(time_entries)'),
                        _pragmaChip('materials', 'PRAGMA table_info(materials)'),
                        _pragmaChip('invoices', 'PRAGMA table_info(invoices)'),
                        _pragmaChip('employees', 'PRAGMA table_info(employees)'),
                        _pragmaChip(
                            'cost_codes', 'PRAGMA table_info(cost_codes)'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _executeQuery();
                            setDialogState(() {});
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Execute'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _sqlController.clear();
                            _queryResults = null;
                            _queryError = null;
                            _mutationResult = null;
                          });
                          setDialogState(() {});
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_queryError != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.red.shade100,
                      child: SelectableText(
                        'Error: $_queryError',
                        style: const TextStyle(
                          color: Colors.red,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_mutationResult != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.green.shade100,
                      child: Text(
                        _mutationResult!,
                        style: TextStyle(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_queryResults != null) ...[
                    Text(
                      'Results: ${_queryResults!.length} rows',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _queryResults!.isEmpty
                          ? const Center(child: Text('No results'))
                          : _ResultsTable(rows: _queryResults!),
                    ),
                  ] else if (_queryError == null && _mutationResult == null)
                    const Expanded(
                      child:
                          Center(child: Text('Enter a query and press Execute')),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pragmaChip(String label, String sql) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        onPressed: () => _sqlController.text = sql,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  // ---- Schema viewer -------------------------------------------------------

  Future<void> _showDatabaseSchema() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final rows = await _db.customSelect(
        "SELECT name, sql FROM sqlite_master WHERE type = 'table' "
        "AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'android_%' "
        'ORDER BY name',
      ).get();
      final tables = rows.map((r) => r.data).toList();

      final schema = tables.isEmpty
          ? 'No user-created tables found in the database.'
          : (StringBuffer()
                ..writeln('DATABASE SCHEMA:\n')
                ..writeAll(
                  tables.map((t) {
                    final creationSql = t['sql']
                            ?.toString()
                            .replaceAll(', ', ',\n  ') ??
                        'Could not retrieve schema.';
                    return '--- TABLE: ${t['name']} ---\n$creationSql;\n\n';
                  }),
                ))
              .toString();

      if (!mounted) return;
      Navigator.pop(context); // dismiss spinner

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Database Schema'),
          content: Scrollbar(
            child: SingleChildScrollView(
              child: SelectableText(
                schema,
                style:
                    const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error Fetching Schema'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  // ---- Build ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Viewer (Dev)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'Run SQL Query',
            onPressed: _showQueryRunner,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'View Database Schema',
            onPressed: _showDatabaseSchema,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDevBanner(),
          _buildFilterControls(),
          Expanded(
            child: FutureBuilder<List<_RecordRow>>(
              key: ValueKey(_refreshKey),
              future: _loadRecords(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'AN ERROR OCCURRED:\n\n${snapshot.error}',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final all = snapshot.data ?? const <_RecordRow>[];
                if (all.isEmpty) {
                  return const Center(
                      child: Text('No records found in the database.'));
                }
                final records = _filterAndSort(all);
                if (records.isEmpty) {
                  return const Center(
                      child: Text('No records match the current filter.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 80),
                  itemCount: records.length,
                  itemBuilder: (context, i) => _buildRecordCard(records[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.orange.shade100,
      child: Center(
        child: Text(
          '⚠ DEV TOOL — Not included in release builds',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade900,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey.shade200,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _recordFilter,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Show',
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Records')),
                DropdownMenuItem(
                    value: 'time', child: Text('Time Entries Only')),
                DropdownMenuItem(
                    value: 'expense', child: Text('Expenses Only')),
              ],
              onChanged: (value) => setState(() => _recordFilter = value!),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _sortBy,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Sort By',
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'date_asc', child: Text('Date (Oldest First)')),
                DropdownMenuItem(
                    value: 'id_desc', child: Text('ID (Newest First)')),
              ],
              onChanged: (value) => setState(() => _sortBy = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(_RecordRow r) {
    final icon = r.isTime ? Icons.timer_outlined : Icons.shopping_cart_outlined;
    final color = r.isTime ? Colors.blue.shade400 : Colors.green.shade400;
    final date = DateFormat.yMMMd().format(r.date);
    final value = r.isTime
        ? '${r.value.toStringAsFixed(2)} h'
        : NumberFormat.simpleCurrency().format(r.value);

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 2, 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID ${r.id} · ${r.description}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$date · ${r.categoryOrProject}',
                    style: const TextStyle(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

/// One row in the combined records list (a time entry or an expense).
class _RecordRow {
  _RecordRow({
    required this.id,
    required this.isTime,
    required this.date,
    required this.description,
    required this.value,
    required this.categoryOrProject,
  });

  final int id;
  final bool isTime;
  final DateTime date;
  final String description;
  final double value;
  final String categoryOrProject;
}

/// Horizontally + vertically scrollable grid for a list of row maps.
class _ResultsTable extends StatelessWidget {
  const _ResultsTable({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    final columns = rows.first.keys.toList();
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Colors.blue.shade100),
            border: TableBorder.all(color: Colors.grey),
            columns: columns
                .map((key) => DataColumn(
                      label: Text(
                        key,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                .toList(),
            rows: rows
                .map((row) => DataRow(
                      cells: columns
                          .map((key) => DataCell(
                                SelectableText(
                                  row[key]?.toString() ?? 'NULL',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ))
                          .toList(),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
