import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/database_provider.dart';

/// "Rates" tab. Two DISTINCT rates, saved independently:
///
///   * **Default Billing Rate** (`settings.companyHourlyRate`, stored in
///     **cents**) — what a client is charged per hour on a project that has no
///     `billedHourlyRate` of its own. This is the value the billing fallback in
///     `hourlyRateCents` reads.
///   * **Burden Rate** (`settings.burdenRate`, stored in **dollars**) — the
///     internal cost of an hour of labour. Feeds margin/analytics only and must
///     never bill a client.
///
/// These were previously one input written to both columns, which meant
/// fallback-billed work was invoiced at exactly cost (zero margin). They are
/// deliberately separate now — do not re-merge them.
class BurdenRateTab extends ConsumerStatefulWidget {
  const BurdenRateTab({super.key});

  @override
  ConsumerState<BurdenRateTab> createState() => _BurdenRateTabState();
}

class _BurdenRateTabState extends ConsumerState<BurdenRateTab> {
  /// Default Billing Rate, in dollars as typed (persisted as cents).
  final _billingRateController = TextEditingController();

  /// Burden Rate, in dollars as typed (persisted as dollars).
  final _burdenRateController = TextEditingController();
  final _overheadController = TextEditingController();
  final _wagesController = TextEditingController();
  final _hoursController = TextEditingController();
  final _profitController = TextEditingController();
  double? _calculatedRate;
  bool _loading = true;

  AppDatabase get _db => ref.read(databaseProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _billingRateController.dispose();
    _burdenRateController.dispose();
    _overheadController.dispose();
    _wagesController.dispose();
    _hoursController.dispose();
    _profitController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final s = await _db.settingsDao.getSettings();
    if (s?.companyHourlyRate != null) {
      _billingRateController.text =
          (s!.companyHourlyRate! / 100).toStringAsFixed(2);
    }
    if (s?.burdenRate != null) {
      _burdenRateController.text = s!.burdenRate!.toStringAsFixed(2);
    }
    if (mounted) setState(() => _loading = false);
  }

  /// Saves the Default Billing Rate ONLY. `saveSettings` writes just the
  /// columns present on the companion, so the burden rate is left untouched.
  Future<void> _saveBillingRate(double rate) async {
    await _db.settingsDao.saveSettings(
      SettingsCompanion(companyHourlyRate: Value((rate * 100).round())),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Default billing rate saved: \$${rate.toStringAsFixed(2)}/hour'),
      ),
    );
  }

  /// Saves the Burden Rate ONLY — never the billing rate.
  Future<void> _saveBurdenRate(double rate) async {
    await _db.settingsDao.saveSettings(
      SettingsCompanion(burdenRate: Value(rate)),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Burden rate saved: \$${rate.toStringAsFixed(2)}/hour'),
      ),
    );
  }

  void _calculate() {
    final overhead = double.tryParse(_overheadController.text) ?? 0;
    final wages = double.tryParse(_wagesController.text) ?? 0;
    final hours = double.tryParse(_hoursController.text) ?? 0;
    final profit = double.tryParse(_profitController.text) ?? 0;

    if (hours <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid billable hours')),
      );
      return;
    }

    final totalCosts = overhead + wages;
    final totalWithProfit = totalCosts + totalCosts * (profit / 100);
    setState(() => _calculatedRate = totalWithProfit / hours);
  }

  static final _moneyFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
  ];

  /// Compact, outlined field style matching the General & Reports tab.
  InputDecoration _dec(String label, {String? hint, String? prefix, String? suffix}) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefix,
        suffixText: suffix,
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
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Default Billing Rate',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Charged to the client on any project that has no hourly '
                    'rate of its own.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _billingRateController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: _moneyFormatter,
                          decoration: _dec('Default Billing Rate',
                              prefix: '\$', suffix: '/hour'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final rate =
                              double.tryParse(_billingRateController.text);
                          if (rate != null && rate > 0) {
                            _saveBillingRate(rate);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter a valid rate')),
                            );
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Burden Rate',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    'Your internal cost per labour hour. Used for margin and '
                    'analytics only — never billed to a client.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _burdenRateController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: _moneyFormatter,
                          decoration: _dec('Burden Rate',
                              prefix: '\$', suffix: '/hour'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final rate =
                              double.tryParse(_burdenRateController.text);
                          if (rate != null && rate > 0) {
                            _saveBurdenRate(rate);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please enter a valid rate')),
                            );
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Burden Rate Calculator',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _overheadController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: _moneyFormatter,
                          decoration: _dec('Annual Overhead', prefix: '\$'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _wagesController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: _moneyFormatter,
                          decoration: _dec('Annual Wages', prefix: '\$'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _hoursController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: _moneyFormatter,
                          decoration: _dec('Billable Hours/Year'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _profitController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: _moneyFormatter,
                          decoration: _dec('Profit Margin', suffix: '%'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _calculate,
                        child: const Text('Calculate'),
                      ),
                      const SizedBox(width: 12),
                      if (_calculatedRate != null)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  Colors.green.withAlpha((255 * 0.1).round()),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Calculated Rate: \$${_calculatedRate!.toStringAsFixed(2)}/hour',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Calculates a COST figure, so it fills and
                                    // saves the burden rate only — never the
                                    // billing rate.
                                    final rateToSave = _calculatedRate!;
                                    _burdenRateController.text =
                                        rateToSave.toStringAsFixed(2);
                                    _saveBurdenRate(rateToSave);
                                    setState(() => _calculatedRate = null);
                                  },
                                  child: const Text('Use as Burden Rate & Save'),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
