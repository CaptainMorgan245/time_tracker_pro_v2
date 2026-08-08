import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

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

/// **Project Statement** — one project's complete payment history: the deposit,
/// every subsequent draw, and where each one stands, with no date filter (the
/// screen is already scoped to a single project's full history).
///
/// Opened either with a [projectId] — drilled into from the client statement —
/// or without one, in which case it shows a searchable, client-grouped project
/// picker first.
///
/// Shares [buildProjectStatement] and [StatementLedgerView] with the client
/// statement, so a project reads identically in both places.
class ProjectStatementScreen extends ConsumerWidget {
  const ProjectStatementScreen({super.key, this.projectId});

  /// Null when opened from the drawer — the picker supplies one.
  final int? projectId;

  /// Builds the PDF and opens the in-app preview — same pattern as the invoice
  /// screen, so printing happens from a route the user can back out of.
  Future<void> _preview(BuildContext context, WidgetRef ref, int id) async {
    await _withPdf(context, ref, id, (bytes, statement) async {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => PdfPreviewScreen(
          title: '${statement.project.projectName} — Statement',
          fileName: _fileName(statement),
          bytes: bytes,
        ),
      ));
    });
  }

  Future<void> _share(BuildContext context, WidgetRef ref, int id) async {
    await _withPdf(context, ref, id, (bytes, statement) async {
      await Printing.sharePdf(bytes: bytes, filename: _fileName(statement));
    });
  }

  /// Renders the statement and hands the bytes to [then]. Company settings are
  /// read here rather than in the service, keeping the PDF layer free of
  /// Drift/Riverpod.
  Future<void> _withPdf(
    BuildContext context,
    WidgetRef ref,
    int id,
    Future<void> Function(Uint8List bytes, ProjectStatement statement) then,
  ) async {
    final statement = ref.read(projectStatementProvider(id)).asData?.value;
    if (statement == null) return;
    try {
      final company = ref.read(companySettingsStreamProvider).asData?.value;
      final bytes = await StatementPdfService.buildProjectStatement(
        statement,
        company: company,
        generatedAt: DateTime.now(),
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

  static String _fileName(ProjectStatement s) {
    final name =
        s.project.projectName.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_');
    return 'Statement_$name.pdf';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = projectId;
    if (id == null) return const _ProjectPicker();

    final statementA = ref.watch(projectStatementProvider(id));
    final hasStatement = statementA.asData?.value != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(statementA.asData?.value?.project.projectName ??
            'Project Statement'),
      ),
      // Export actions live in a bottom bar rather than as AppBar actions, so
      // they carry their labels in the same treatment the invoice screen uses.
      body: Column(
        children: [
          Expanded(
            child: AsyncValueView<ProjectStatement?>(
              value: statementA,
              builder: (statement) {
                if (statement == null) {
                  return const Center(child: Text('Project not found.'));
                }
                return _StatementView(statement: statement);
              },
            ),
          ),
          PdfActionBar(
            onPreview: hasStatement ? () => _preview(context, ref, id) : null,
            onShare: hasStatement ? () => _share(context, ref, id) : null,
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Statement
// ===========================================================================

class _StatementView extends StatelessWidget {
  const _StatementView({required this.statement});

  final ProjectStatement statement;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Bottom inset is owned by the action bar's SafeArea now, so this is a
      // plain margin.
      padding: const EdgeInsets.all(16),
      children: [
        _header(),
        const SizedBox(height: 12),
        StatementStatusBanner(statement: statement),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: StatementLedgerView(statement: statement),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    final contract = statement.contractAmountCents;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(statement.project.projectName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(statement.clientName,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade800)),
            const SizedBox(height: 8),
            Text(
              [
                statement.isFixedPrice ? 'Fixed-Price' : 'Time & Materials',
                if (contract != null)
                  'Contract ${formatStatementAmount(contract)}',
                statement.isCompleted ? 'Completed' : 'In progress',
              ].join('  •  '),
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Picker
// ===========================================================================

/// Searchable project list grouped by client. The query matches project OR
/// client name, so a client's whole set of jobs can be pulled up at once —
/// including independent add-on projects that merely share a naming prefix.
///
/// Stateful only to own the search [TextEditingController] — the query itself
/// lives in [projectSearchProvider], matching how the invoice forms and the
/// Cost Entry amount lookup split text controllers (widget layer) from state
/// (provider layer).
class _ProjectPicker extends ConsumerStatefulWidget {
  const _ProjectPicker();

  @override
  ConsumerState<_ProjectPicker> createState() => _ProjectPickerState();
}

class _ProjectPickerState extends ConsumerState<_ProjectPicker> {
  late final TextEditingController _search =
      TextEditingController(text: ref.read(projectSearchProvider));

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clear() {
    _search.clear();
    ref.read(projectSearchProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final groupsA = ref.watch(projectPickerProvider);
    final query = ref.watch(projectSearchProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Project Statement')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                labelText: 'Search projects or clients',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                filled: true,
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clear,
                      ),
              ),
              onChanged: (v) =>
                  ref.read(projectSearchProvider.notifier).set(v),
            ),
          ),
          Expanded(
            child: AsyncValueView<List<ProjectPickerGroup>>(
              value: groupsA,
              builder: (groups) {
                if (groups.isEmpty) {
                  return const Center(
                    child: Text('No matching projects.',
                        style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListView(
                  padding: EdgeInsets.fromLTRB(
                      16, 0, 16, 16 + MediaQuery.of(context).padding.bottom),
                  children: [
                    for (final g in groups) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                        child: Text(
                          g.clientName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      for (final p in g.projects)
                        Card(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: ListTile(
                            dense: true,
                            title: Text(p.projectName),
                            subtitle: Text(
                              [
                                p.pricingModel == 'fixed'
                                    ? 'Fixed-Price'
                                    : 'Time & Materials',
                                if (p.isCompleted != 0) 'Completed',
                              ].join('  •  '),
                              style: const TextStyle(fontSize: 11),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    ProjectStatementScreen(projectId: p.id),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
