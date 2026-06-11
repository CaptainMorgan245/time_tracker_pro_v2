import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/repositories/backup_import_repository.dart';
import '../providers/backup_providers.dart';

/// Lets the user restore the app from a JSON backup produced by the original
/// Time Tracker Pro app. Importing is destructive — it wipes and replaces all
/// existing data — so the user must confirm before it runs.
class DataManagementScreen extends ConsumerWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final importState = ref.watch(importControllerProvider);

    // Surface completion / failure as a snackbar, in addition to the inline
    // summary rendered in the body.
    ref.listen<AsyncValue<BackupImportResult?>>(importControllerProvider,
        (prev, next) {
      next.whenOrNull(
        data: (result) {
          if (result == null) return; // initial idle state
          _showSnack(
            context,
            '✅ Imported ${result.totalRows} rows.',
            color: Colors.green,
          );
        },
        error: (error, _) => _showSnack(
          context,
          '❌ Import failed: $error. Your existing data was preserved.',
          color: Colors.red,
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Data Management')),
      body: importState.isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Importing backup…'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ImportCard(
                  onImport: () => _pickAndImport(context, ref),
                ),
                const SizedBox(height: 16),
                ...importState.when(
                  data: (result) => result == null
                      ? const []
                      : [_ResultCard(result: result)],
                  loading: () => const [],
                  error: (error, _) => [_ErrorCard(message: '$error')],
                ),
              ],
            ),
    );
  }

  Future<void> _pickAndImport(BuildContext context, WidgetRef ref) async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true, // load bytes in memory — works on web, mobile and desktop
    );
    if (picked == null) return; // user cancelled

    final bytes = picked.files.single.bytes;
    if (bytes == null) {
      if (context.mounted) {
        _showSnack(context, 'Could not read the selected file.',
            color: Colors.red);
      }
      return;
    }

    final jsonString = utf8.decode(bytes);
    if (jsonString.trim().isEmpty) {
      if (context.mounted) {
        _showSnack(context, 'The selected backup file is empty.',
            color: Colors.red);
      }
      return;
    }

    if (!context.mounted) return;
    final confirmed = await _confirmOverwrite(context);
    if (confirmed != true) return;

    await ref.read(importControllerProvider.notifier).importFromJson(jsonString);
  }

  Future<bool?> _confirmOverwrite(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Overwrite all data?'),
        content: const Text(
          'Restoring from this backup will completely ERASE and REPLACE all '
          'current data in the app. This cannot be undone.\n\n'
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Yes, overwrite',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message, {required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}

class _ImportCard extends StatelessWidget {
  const _ImportCard({required this.onImport});

  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restore from backup',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Import a .json backup exported from Time Tracker Pro. This '
              'replaces all data currently in this app.',
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onImport,
                icon: const Icon(Icons.upload_file),
                label: const Text('Import from backup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final BackupImportResult result;

  @override
  Widget build(BuildContext context) {
    final tableEntries = result.rowsByTable.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import complete — ${result.totalRows} rows',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            ...tableEntries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key),
                    Text('${e.value}'),
                  ],
                ),
              ),
            ),
            if (result.warnings.isNotEmpty) ...[
              const Divider(),
              Text(
                'Warnings',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              ...result.warnings.map(
                (w) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('• $w'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import failed',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.red.shade900),
            ),
            const SizedBox(height: 8),
            Text(message),
            const SizedBox(height: 8),
            const Text('Your existing data was preserved.'),
          ],
        ),
      ),
    );
  }
}
