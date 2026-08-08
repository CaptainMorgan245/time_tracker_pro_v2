import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../data/local/drift/app_database.dart';
import '../../providers/invoice_providers.dart'
    show companySettingsStreamProvider;
import '../../providers/statement_providers.dart';
import '../../services/statement_pdf_service.dart';
import '../../widgets/async_value_view.dart';
import '../../widgets/pdf_action_bar.dart';
import '../../widgets/statement_ledger_view.dart';
import '../../widgets/statement_row.dart';
import '../../widgets/statement_status_banner.dart';
import '../pdf_preview_screen.dart';
import 'project_statement_screen.dart';

final _dateFmt = DateFormat('MMM d, yyyy');

/// **Client Statement** — one client's financial history across every project
/// they own: one row per project with its contract type, contract amount,
/// billed-to-date and status, each expanding to the invoice ledger behind it.
///
/// Not an invoice. It answers "what has this client been billed and what have
/// they paid", so every non-deleted invoice counts regardless of type —
/// including above-contract `'extras'` (see `statement_providers.dart`).
///
/// Projects are flat. A client's jobs are independent top-level projects even
/// when their names suggest otherwise ("101 Kolumbia" and "101 Kolumbia - Deck"
/// are two rows), and no parent/child relationship is read or inferred.
///
/// State lives entirely in providers ([statementFilterProvider],
/// [clientStatementProvider]); this screen holds none of its own.
class ClientStatementScreen extends ConsumerWidget {
  const ClientStatementScreen({super.key});

  /// Builds the PDF and opens the in-app preview, matching the invoice screen's
  /// pattern: the preview is a pushed route the user can close, and printing
  /// happens from inside it rather than jumping to the platform print UI.
  Future<void> _preview(BuildContext context, WidgetRef ref) async {
    await _withPdf(context, ref, (bytes, statement) async {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => PdfPreviewScreen(
          title: '${statement.client.name} — Statement',
          fileName: _fileName(statement),
          bytes: bytes,
        ),
      ));
    });
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    await _withPdf(context, ref, (bytes, statement) async {
      await Printing.sharePdf(bytes: bytes, filename: _fileName(statement));
    });
  }

  /// Renders the current statement and hands the bytes to [then]. Reads the
  /// company settings here rather than in the service, keeping the PDF layer
  /// free of Drift/Riverpod. Failures surface as a red SnackBar, as on the
  /// invoice screen.
  Future<void> _withPdf(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function(Uint8List bytes, ClientStatement statement) then,
  ) async {
    final statement = ref.read(clientStatementProvider).asData?.value;
    if (statement == null) return; // no client selected yet
    try {
      final company = ref.read(companySettingsStreamProvider).asData?.value;
      final bytes = await StatementPdfService.buildClientStatement(
        statement,
        company: company,
      );
      if (!context.mounted) return;
      await then(bytes, statement);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not generate PDF: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  static String _fileName(ClientStatement s) {
    final client = s.client.name.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
    return 'Statement_$client.pdf';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statementA = ref.watch(clientStatementProvider);
    // Export is meaningless until a client is chosen, so the actions are
    // disabled rather than producing an empty document.
    final hasStatement = statementA.asData?.value != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Client Statement')),
      // Export actions live in a bottom bar rather than as AppBar actions, so
      // they carry their labels in the same treatment the invoice screen uses.
      body: Column(
        children: [
          Expanded(child: _body(statementA)),
          PdfActionBar(
            onPreview: hasStatement ? () => _preview(context, ref) : null,
            onShare: hasStatement ? () => _share(context, ref) : null,
          ),
        ],
      ),
    );
  }

  Widget _body(AsyncValue<ClientStatement?> statementA) {
    return ListView(
      // Bottom inset is owned by the action bar's SafeArea now, so this is a
      // plain margin.
      padding: const EdgeInsets.all(16),
      children: [
        const _FilterCard(),
        const SizedBox(height: 16),
        AsyncValueView<ClientStatement?>(
          value: statementA,
          builder: (statement) {
            if (statement == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('Select a client to view their statement.',
                      style: TextStyle(color: Colors.grey)),
                ),
              );
            }
            return _Results(statement: statement);
          },
        ),
      ],
    );
  }
}

// ===========================================================================
// Filters
// ===========================================================================

class _FilterCard extends StatelessWidget {
  const _FilterCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ClientDropdown(),
            SizedBox(height: 16),
            _PeriodSelector(),
          ],
        ),
      ),
    );
  }
}

class _ClientDropdown extends ConsumerWidget {
  const _ClientDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsA = ref.watch(statementClientsProvider);
    final filter = ref.watch(statementFilterProvider);

    return AsyncValueView<List<DbClient>>(
      value: clientsA,
      builder: (clients) {
        // Guard against a stale id (client archived while selected).
        final ids = clients.map((c) => c.id).toSet();
        final value =
            ids.contains(filter.clientId) ? filter.clientId : null;

        return DropdownButtonFormField<int?>(
          isExpanded: true,
          initialValue: value,
          decoration: const InputDecoration(
            labelText: 'Client',
            border: OutlineInputBorder(),
            filled: true,
          ),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('Select a client…'),
            ),
            ...clients.map((c) => DropdownMenuItem<int?>(
                  value: c.id,
                  child: Text(c.name, overflow: TextOverflow.ellipsis),
                )),
          ],
          onChanged: (v) =>
              ref.read(statementFilterProvider.notifier).setClient(v),
        );
      },
    );
  }
}

/// Period presets. Defaults to `settings.defaultReportMonths` until the user
/// picks one — see [effectiveStatementPeriodProvider].
class _PeriodSelector extends ConsumerWidget {
  const _PeriodSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(statementFilterProvider);
    final periodA = ref.watch(effectiveStatementPeriodProvider);
    final selected = periodA.asData?.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Period',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey.shade700)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final p in StatementPeriod.values)
              ChoiceChip(
                label: Text(p == StatementPeriod.custom
                    ? _customLabel(filter.customRange)
                    : p.label),
                selected: selected == p,
                onSelected: (_) => _select(context, ref, p),
              ),
          ],
        ),
      ],
    );
  }

  static String _customLabel(DateTimeRange? range) => range == null
      ? 'Custom range…'
      : '${_dateFmt.format(range.start)} – ${_dateFmt.format(range.end)}';

  Future<void> _select(
      BuildContext context, WidgetRef ref, StatementPeriod period) async {
    final notifier = ref.read(statementFilterProvider.notifier);
    if (period != StatementPeriod.custom) {
      notifier.setPeriod(period);
      return;
    }
    final existing = ref.read(statementFilterProvider).customRange;
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: existing,
    );
    // Cancelling leaves the current period untouched rather than switching to
    // an empty custom range (which would silently mean "all time").
    if (picked != null) notifier.setCustomRange(picked);
  }
}

// ===========================================================================
// Results
// ===========================================================================

class _Results extends StatelessWidget {
  const _Results({required this.statement});

  final ClientStatement statement;

  @override
  Widget build(BuildContext context) {
    final windowed = statement.window != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 12),
        if (statement.projects.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No projects to show for this client in the '
                  'selected period.'),
            ),
          )
        else
          for (final p in statement.projects)
            _ProjectCard(statement: p, windowed: windowed),
        const SizedBox(height: 12),
        _GrandTotals(statement: statement, windowed: windowed),
      ],
    );
  }

  Widget _header() {
    final w = statement.window;
    final range = w == null
        ? 'All time'
        : '${_dateFmt.format(w.start)} – ${_dateFmt.format(w.end)}';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(statement.client.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              '${statement.period.label}  •  $range  •  '
              'Generated ${_dateFmt.format(statement.generatedAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

/// One project row, expanding to its ledger.
class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.statement, required this.windowed});

  final ProjectStatement statement;
  final bool windowed;

  @override
  Widget build(BuildContext context) {
    final contract = statement.contractAmountCents;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        title: Row(
          children: [
            Expanded(
              child: Text(statement.project.projectName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            _TypeBadge(isFixedPrice: statement.isFixedPrice),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                [
                  if (contract != null)
                    'Contract ${formatStatementAmount(contract)}',
                  'Billed${windowed ? ' (period)' : ''} '
                      '${formatStatementAmount(statement.windowBilledCents)}',
                ].join('  •  '),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 2),
              StatementStatusLine(statement: statement),
            ],
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          StatementLedgerView(statement: statement, windowed: windowed),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Open full statement'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      ProjectStatementScreen(projectId: statement.project.id),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.isFixedPrice});

  final bool isFixedPrice;

  @override
  Widget build(BuildContext context) {
    final color = isFixedPrice ? Colors.indigo.shade700 : Colors.teal.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isFixedPrice ? 'FIXED' : 'T&M',
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}

/// Grand totals across the client's projects.
///
/// Balance Owing covers only projects that have reached a final number, and the
/// count of those still open is stated rather than left implied — summing open
/// projects here would contradict the per-row rule that an unfinished project
/// claims no balance.
///
/// "Still open" now means exactly one thing: the project isn't marked complete.
/// A completed project is always counted, whether it was paid in full, still
/// owes a balance, or was never invoiced — none of which depends on invoice type
/// or on total billed matching the contract price.
class _GrandTotals extends StatelessWidget {
  const _GrandTotals({required this.statement, required this.windowed});

  final ClientStatement statement;
  final bool windowed;

  @override
  Widget build(BuildContext context) {
    final suffix = windowed ? ' (in period)' : '';
    final open = statement.openProjectCount;
    return Card(
      color: Colors.blueGrey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Grand Totals',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StatementAmountRow(
              label: 'Total Billed$suffix',
              cents: statement.windowBilledCents,
              bold: true,
            ),
            StatementAmountRow(
              label: 'Total Paid$suffix',
              cents: statement.windowPaidCents,
              bold: true,
            ),
            const StatementAmountRule(),
            StatementAmountRow(
              label: 'Balance Owing (completed projects)',
              cents: statement.closedBalanceOwingCents,
              bold: true,
              emphasis: true,
            ),
            if (open > 0)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  open == 1
                      ? '1 project not yet complete — its balance is not final '
                          'and is excluded above.'
                      : '$open projects not yet complete — their balances are '
                          'not final and are excluded above.',
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
