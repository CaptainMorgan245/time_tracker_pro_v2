import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/repositories/backup_repository.dart';
import '../providers/backup_providers.dart';

/// Data Management, ported from the original app: export a full backup, restore
/// from a backup (destructive replace), and clear all data (destructive wipe +
/// re-seed). Each action is driven by its own `AsyncNotifier` controller; this
/// widget only renders state and runs the confirm/name dialogs.
class DataManagementScreen extends ConsumerWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Import completion / failure also surfaces as a snackbar (in addition to
    // the inline summary card below).
    ref.listen<AsyncValue<BackupImportResult?>>(importControllerProvider,
        (prev, next) {
      next.whenOrNull(
        data: (result) {
          if (result == null) return; // initial idle state
          _snack(context, '✅ Imported ${result.totalRows} rows.',
              color: Colors.green);
        },
        error: (error, _) => _snack(
          context,
          '❌ Import failed: $error. Your existing data was preserved.',
          color: Colors.red,
        ),
      );
    });

    final exporting = ref.watch(exportControllerProvider).isLoading;
    final importing = ref.watch(importControllerProvider).isLoading;
    final clearing = ref.watch(clearDataControllerProvider).isLoading;
    final importState = ref.watch(importControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Data Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sectionHeader(context, 'Database Backup & Restore'),
            const SizedBox(height: 8),
            _infoCard(
              'Export a full .json backup, or restore from a backup file. '
              'Restoring replaces all data currently in this app.',
            ),
            const SizedBox(height: 24),
            _actionButton(
              context: context,
              icon: Icons.file_upload_outlined,
              label: exporting ? 'Saving…' : 'Export Full Backup',
              loading: exporting,
              onPressed:
                  exporting ? null : () => _export(context, ref),
            ),
            const SizedBox(height: 16),
            _actionButton(
              context: context,
              icon: Icons.file_download_outlined,
              label: importing ? 'Importing…' : 'Import From Backup',
              loading: importing,
              onPressed:
                  importing ? null : () => _pickAndImport(context, ref),
            ),
            ...importState.when(
              data: (result) => result == null
                  ? const <Widget>[]
                  : [const SizedBox(height: 16), _ResultCard(result: result)],
              loading: () => const <Widget>[],
              error: (error, _) =>
                  [const SizedBox(height: 16), _ErrorCard(message: '$error')],
            ),
            const Divider(height: 48),
            _sectionHeader(context, 'Danger Zone'),
            const SizedBox(height: 8),
            _infoCard(
              'These actions are destructive and cannot be undone. Use with '
              'extreme caution.',
            ),
            const SizedBox(height: 24),
            _actionButton(
              context: context,
              icon: Icons.delete_forever_outlined,
              label: clearing ? 'Clearing…' : 'Clear All Data',
              loading: clearing,
              color: Colors.red.shade700,
              onPressed: clearing ? null : () => _clear(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Export --------------------------------------------------------------

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    // On web the OS save picker provides the name + location, and it must open
    // synchronously from this gesture — so we must NOT await our own dialog
    // first. On native, there's no picker, so we ask for an optional name.
    String? customName;
    if (!kIsWeb) {
      customName = await _askBackupName(context);
      if (customName == null) return; // dialog cancelled
    }

    await ref.read(exportControllerProvider.notifier).export(
          customName: (customName != null && customName.isNotEmpty)
              ? customName
              : null,
        );
    if (!context.mounted) return;
    final s = ref.read(exportControllerProvider);
    if (s.hasError) {
      _snack(context, '❌ Export failed: ${s.error}', color: Colors.red);
    } else if (s.value == null) {
      // Web save dialog dismissed — nothing was written.
      _snack(context, 'Export cancelled.', color: Colors.blueGrey);
    } else {
      // Web/PWA: the user chose the location via the save dialog.
      // Android: written to the device Download folder.
      final message = kIsWeb
          ? '✅ Backup saved as ${s.value}'
          : '✅ Backup saved to Download/${s.value}';
      _snack(context, message, color: Colors.green);
    }
  }

  /// Returns the entered name (possibly empty for auto-generated), or null if
  /// the user cancelled.
  Future<String?> _askBackupName(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Name'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter a custom name (optional):'),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g., Before_Tax_Season',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Leave blank for an auto-generated name.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  // ---- Import --------------------------------------------------------------

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
        _snack(context, 'Could not read the selected file.', color: Colors.red);
      }
      return;
    }

    final jsonString = utf8.decode(bytes);
    if (jsonString.trim().isEmpty) {
      if (context.mounted) {
        _snack(context, 'The selected backup file is empty.',
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
            child: const Text('Yes, overwrite',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ---- Clear ---------------------------------------------------------------

  Future<void> _clear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Delete all data? This cannot be undone. The app will reset to a '
          'clean slate (default settings and the internal Company Expenses '
          'project are restored).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DELETE ALL DATA',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(clearDataControllerProvider.notifier).clear();
    if (!context.mounted) return;
    final s = ref.read(clearDataControllerProvider);
    if (s.hasError) {
      _snack(context, '❌ Failed to clear data: ${s.error}', color: Colors.red);
    } else {
      _snack(context, '✅ All data cleared. The app has been reset.',
          color: Colors.green);
    }
  }

  // ---- Shared UI helpers ---------------------------------------------------

  void _snack(BuildContext context, String message, {required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
    );
  }

  Widget _infoCard(String text) {
    return Card(
      elevation: 0,
      color: Colors.blueGrey.withAlpha(26),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.blueGrey.withAlpha(51)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text, style: const TextStyle(height: 1.5)),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool loading,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;
    final onButtonColor = theme.colorScheme.onPrimary;
    return ElevatedButton.icon(
      icon: loading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: onButtonColor),
            )
          : Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: onButtonColor,
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: theme.textTheme.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  children: [Text(e.key), Text('${e.value}')],
                ),
              ),
            ),
            if (result.warnings.isNotEmpty) ...[
              const Divider(),
              Text('Warnings',
                  style: Theme.of(context).textTheme.titleSmall),
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
