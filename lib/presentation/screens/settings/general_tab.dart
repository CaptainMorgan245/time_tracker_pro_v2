import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/database_provider.dart';

/// "General & Reports" tab. Owns the general app-level fields of the `settings`
/// table: employee numbering, time rounding, measurement system, expense markup.
class GeneralTab extends ConsumerStatefulWidget {
  const GeneralTab({super.key});

  @override
  ConsumerState<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends ConsumerState<GeneralTab> {
  final _prefixController = TextEditingController();
  final _nextNumberController = TextEditingController();
  final _markupController = TextEditingController();
  int _timeRoundingInterval = 15;
  String _measurementSystem = 'metric';
  bool _loading = true;

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _prefixController.dispose();
    _nextNumberController.dispose();
    _markupController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final s = await _db.settingsDao.getSettings();
    if (s != null) {
      _prefixController.text = s.employeeNumberPrefix ?? '';
      _nextNumberController.text = s.nextEmployeeNumber?.toString() ?? '1';
      _markupController.text =
          (s.expenseMarkupPercentage ?? 0.0).toStringAsFixed(2);
      _timeRoundingInterval = s.timeRoundingInterval ?? 15;
      _measurementSystem = s.measurementSystem ?? 'metric';
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    await _db.settingsDao.saveSettings(
      SettingsCompanion(
        employeeNumberPrefix: Value(
          _prefixController.text.isEmpty ? null : _prefixController.text,
        ),
        nextEmployeeNumber: Value(int.tryParse(_nextNumberController.text)),
        expenseMarkupPercentage:
            Value(double.tryParse(_markupController.text) ?? 0.0),
        timeRoundingInterval: Value(_timeRoundingInterval),
        measurementSystem: Value(_measurementSystem),
        setupCompleted: const Value(1),
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('General settings saved!')),
    );
  }

  void _showHelpDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.help_outline, color: Colors.blueGrey),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got It'),
          ),
        ],
      ),
    );
  }

  /// Compact, outlined field style matching the dashboard / cost-entry forms.
  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Employee Numbers',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.help_outline, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _showHelpDialog('Employee Numbers',
                            'Prefix and sequential numbering for staff.'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _prefixController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: _dec('Prefix'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _nextNumberController,
                          keyboardType: TextInputType.number,
                          decoration: _dec('Next #'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Time & Measurement',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _timeRoundingInterval,
                          isExpanded: true,
                          decoration: _dec('Time Rounding'),
                          items: const [
                            DropdownMenuItem(
                                value: 0, child: Text('No Rounding')),
                            DropdownMenuItem(
                                value: 15, child: Text('15 Minutes')),
                            DropdownMenuItem(
                                value: 30, child: Text('30 Minutes')),
                          ],
                          onChanged: (val) =>
                              setState(() => _timeRoundingInterval = val ?? 15),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _measurementSystem,
                          isExpanded: true,
                          decoration: _dec('Units'),
                          items: const [
                            DropdownMenuItem(
                                value: 'metric', child: Text('Metric')),
                            DropdownMenuItem(
                                value: 'imperial', child: Text('Imperial')),
                          ],
                          onChanged: (val) => setState(
                              () => _measurementSystem = val ?? 'metric'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Expenses',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _markupController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: _dec('Expense Markup %'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save General Settings'),
          ),
        ],
      ),
    );
  }
}
