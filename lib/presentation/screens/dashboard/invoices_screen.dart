import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/invoice_providers.dart';
import '../../widgets/async_value_view.dart';
import 'invoice_detail_screen.dart';

final _currency = NumberFormat.currency(symbol: '\$');
String _fmtDate(String iso) {
  final d = DateTime.tryParse(iso);
  return d == null ? '' : DateFormat('MMM d, yyyy').format(d);
}

/// Invoices tab: grouped-by-project list with Active/Paid tabs and a Show Voided
/// toggle. All filtering/grouping lives in [invoiceRowsProvider].
class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(invoiceListFilterProvider);
    final notifier = ref.read(invoiceListFilterProvider.notifier);
    final rowsA = ref.watch(invoiceRowsProvider);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              children: [
                Text(
                  filter.showVoided
                      ? 'Voided'
                      : filter.tab == InvoiceTab.paid
                          ? 'Paid Invoices'
                          : 'Invoices',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                const Text('Show Voided', style: TextStyle(fontSize: 12)),
                Switch(
                  value: filter.showVoided,
                  onChanged: notifier.toggleVoided,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: _navButton(
                    context,
                    label: 'Paid Invoice',
                    icon: Icons.check_circle_outline,
                    color: Colors.green.shade700,
                    onPressed: () => notifier.setTab(InvoiceTab.paid),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _navButton(
                    context,
                    label: 'Estimates',
                    icon: Icons.calculate_outlined,
                    color: Colors.purple.shade700,
                    onPressed: () => _snack(context, 'Estimates coming soon'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _navButton(
                    context,
                    label: 'Fixed Price Invoice',
                    icon: Icons.add,
                    color: Colors.blue.shade700,
                    onPressed: () => _snack(context, 'Coming in Phase 2'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _navButton(
                    context,
                    label: 'Time & Materials Invoice',
                    icon: Icons.checklist,
                    color: Colors.orange.shade700,
                    onPressed: () => _snack(context, 'Coming in Phase 2'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AsyncValueView<List<InvoiceProjectGroup>>(
              value: rowsA,
              builder: (groups) {
                if (groups.isEmpty) {
                  return const Center(child: Text('No invoices to show.'));
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                  children: [
                    for (final g in groups) ..._group(context, g),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label,
          style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  List<Widget> _group(BuildContext context, InvoiceProjectGroup g) {
    final primary = Theme.of(context).colorScheme.primary;
    return [
      Container(
        margin: const EdgeInsets.only(top: 8, bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: primary.withAlpha(20),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(g.projectName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Text(_currency.format(g.total),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      for (final it in g.items) _card(context, it),
    ];
  }

  Widget _card(BuildContext context, InvoiceListItem it) {
    final inv = it.invoice;
    final paid = it.status == InvoiceStatus.paid;
    final voided = it.status == InvoiceStatus.voided;
    final amountColor = voided
        ? Colors.red
        : paid
            ? Colors.green
            : Theme.of(context).colorScheme.primary;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => InvoiceDetailScreen(invoiceId: inv.id),
        )),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Invoice: ${inv.invoiceNumber}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  _StatusChip(status: it.status),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: Text('Client: ${it.clientName}')),
                  Text('Date: ${_fmtDate(inv.invoiceDate)}'),
                ],
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(paid ? 'Amount Paid:' : 'Amount Due:',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(_currency.format(inv.totalAmount / 100),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: amountColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      InvoiceStatus.voided => ('Void', Colors.red),
      InvoiceStatus.paid => ('Paid', Colors.green),
      InvoiceStatus.partial => ('Partial', Colors.orange),
      InvoiceStatus.sent => ('Sent', Colors.blue),
      InvoiceStatus.draft => ('Draft', Colors.orange),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(127)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
