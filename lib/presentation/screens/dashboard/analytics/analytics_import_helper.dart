import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/analytics_providers.dart';

/// Drives the hub's "Import Time" button: pick a JSON file, parse it into
/// [ImportTimeEntryRow]s, hand them to [analyticsImportActionsProvider] (which
/// validates + reconciles), then show a summary of imported rows + errors.
///
/// Expected file shape (a top-level list, or an object with an `entries` list):
/// ```json
/// { "entries": [
///   { "project": "Acme Reno", "employee": "Jane Doe",
///     "start_time": "2026-06-01T08:00:00", "end_time": "2026-06-01T16:00:00",
///     "cost_code": "Framing", "work_details": "..." }
/// ] }
/// ```
/// Field names accept snake_case or camelCase. Validation/reconciliation (unknown
/// project, bad times, etc.) is the provider's job — see [ImportSummary.importErrors].
Future<void> runTimeImport(BuildContext context, WidgetRef ref) async {
  final picked = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json', 'txt'],
    withData: true,
  );
  if (picked == null) return; // cancelled

  final bytes = picked.files.single.bytes;
  if (bytes == null) {
    _snack(context, 'Could not read the selected file.', Colors.red);
    return;
  }

  final text = utf8.decode(bytes);
  List<ImportTimeEntryRow> rows;
  try {
    rows = _parseImportRows(text);
  } catch (e) {
    _snack(context, 'Could not parse file: $e', Colors.red);
    return;
  }
  if (rows.isEmpty) {
    _snack(context, 'No time entries found in the file.', Colors.orange);
    return;
  }

  await ref
      .read(analyticsImportActionsProvider.notifier)
      .importTimeEntries(rows);

  if (!context.mounted) return;
  final state = ref.read(analyticsImportActionsProvider);
  state.when(
    loading: () {},
    error: (e, _) => _snack(context, 'Import failed: $e', Colors.red),
    data: (summary) {
      if (summary == null) return;
      _showSummaryDialog(context, summary);
    },
  );
}

List<ImportTimeEntryRow> _parseImportRows(String text) {
  final decoded = jsonDecode(text);
  final List entries;
  if (decoded is List) {
    entries = decoded;
  } else if (decoded is Map && decoded['entries'] is List) {
    entries = decoded['entries'] as List;
  } else {
    throw const FormatException(
        "Expected a list of entries or an object with an 'entries' list.");
  }

  final rows = <ImportTimeEntryRow>[];
  for (var i = 0; i < entries.length; i++) {
    final e = entries[i];
    if (e is! Map) continue;
    rows.add(ImportTimeEntryRow(
      rowNumber: i + 1,
      projectName: _str(e['project'] ?? e['projectName']),
      employeeName: _str(e['employee'] ?? e['employeeName']),
      startTime: _str(e['start_time'] ?? e['startTime']),
      endTime: _str(e['end_time'] ?? e['endTime']),
      costCodeName: _str(e['cost_code'] ?? e['costCodeName']),
      workDetails: _str(e['work_details'] ?? e['workDetails']),
    ));
  }
  return rows;
}

String? _str(dynamic v) => v?.toString();

void _showSummaryDialog(BuildContext context, ImportSummary summary) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Import Summary'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('✓ Imported: ${summary.imported} of ${summary.totalRows}'),
              if (summary.hasErrors) ...[
                const SizedBox(height: 12),
                Text('✗ ${summary.importErrors.length} could not be imported:',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                const SizedBox(height: 4),
                ...summary.importErrors.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• $e', style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void _snack(BuildContext context, String message, Color color) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: color),
  );
}
