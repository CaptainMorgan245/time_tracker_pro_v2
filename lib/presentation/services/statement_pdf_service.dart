import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/local/drift/app_database.dart';
import '../providers/statement_providers.dart';
import 'pdf_theme.dart';

/// Renders the print-ready client and project statement PDFs (US Letter).
///
/// Same letterhead, palette and type as the invoice — both services compose
/// `pdf_theme.dart` rather than each carrying their own copy, so the branding
/// cannot drift between an invoice and a statement.
///
/// Pure, like `InvoicePdfService`: no Drift and no Riverpod here. Both entry
/// points take the *same* read-models the screens render ([ClientStatement] /
/// [ProjectStatement]), which is what guarantees the printed page can't disagree
/// with what's on screen — the windowed-vs-lifetime rule, the ledger contents
/// and the status wording are all decided upstream in `statement_providers.dart`
/// and simply laid out here.
///
/// A statement is not an invoice, so the footer deliberately drops the payment
/// terms and the "Thank you for your business" line, carrying the accent rule
/// and the GST registration number only.
///
/// The payment address follows the same reasoning and is scoped tightly: a
/// client statement never prints one, and a project statement prints one only
/// while something is still owed. See [_projectOwesSomething].
class StatementPdfService {
  const StatementPdfService._();

  // ── Client statement ──────────────────────────────────────────────────────

  /// One row per project — name, contract type, contract amount, billed, status
  /// — over the statement's date window, followed by the grand totals.
  ///
  /// Carries no payment address. This is a rolled-up record across a client's
  /// projects, not a request for payment on any one of them; a single live
  /// payment prompt beside a list of otherwise-settled projects would be asking
  /// for money without saying which project it belongs to.
  static Future<Uint8List> buildClientStatement(
    ClientStatement statement, {
    required DbCompanySetting? company,
  }) async {
    final windowed = statement.window != null;
    final doc = pw.Document(
      title: 'Statement - ${statement.client.name}',
      author: company?.companyName,
    );

    doc.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.letter,
          margin: pw.EdgeInsets.all(kPdfPageMargin),
        ),
        build: (context) => [
          _letterhead(
            company,
            'STATEMENT',
            [
              'Client: ${statement.client.name}',
              'Period: ${_periodLine(statement)}',
              'Generated: ${pdfDate(statement.generatedAt)}',
            ],
            // Never — a client statement is a rolled-up record across projects,
            // not a request for payment on any one of them.
            showPaymentAddress: false,
          ),
          pw.Divider(color: kPdfAccent, height: 24),
          pdfLabelledBlock('ACCOUNT', [statement.client.name]),
          pw.SizedBox(height: 16),
          if (statement.projects.isEmpty)
            pw.Text('No projects to show for this client in the selected '
                'period.', style: kPdfBody)
          else
            _projectTable(statement, windowed: windowed),
          pw.SizedBox(height: 20),
          _clientTotals(statement, windowed: windowed),
          pw.SizedBox(height: 24),
          _footer(company),
        ],
      ),
    );

    return doc.save();
  }

  /// Whether a project statement should carry the payment address — everything
  /// except a project that is Paid in Full.
  ///
  /// Only the *project* statement asks this. A project statement functions like
  /// a bill for one specific job, so a payment address belongs on it whenever
  /// something is still owed. The client statement is a rolled-up summary across
  /// projects and never carries one — see [buildClientStatement].
  static bool _projectOwesSomething(ProjectStatement s) =>
      s.status != ProjectStatementStatus.paidInFull;

  /// The period as printed: the preset's own label plus the resolved dates, so
  /// "Last 3 months" is never ambiguous about which three months.
  static String _periodLine(ClientStatement s) {
    final w = s.window;
    if (w == null) return s.period.label;
    // Plain hyphen, not an en/em dash: the base-14 PDF font renders those as
    // missing-glyph boxes. Same rule applies to every literal in this file.
    return '${s.period.label} (${pdfDate(w.start)} - ${pdfDate(w.end)})';
  }

  /// Project rows. Billed is the WINDOWED figure (it foots against the period
  /// the statement covers); status is always the lifetime position, matching the
  /// on-screen rule that whether a project is settled is a fact about the
  /// project, not about the window being viewed.
  static pw.Widget _projectTable(ClientStatement s, {required bool windowed}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pdfSectionHeading('PROJECTS'),
        pw.SizedBox(height: 6),
        _tableHeader([
          'Project',
          'Type',
          'Contract',
          windowed ? 'Billed (period)' : 'Billed',
          'Status',
        ], _projectFlex, const [false, false, true, true, false]),
        for (final p in s.projects)
          _tableRow(
            [
              p.project.projectName,
              p.isFixedPrice ? 'Fixed-Price' : 'T&M',
              // T&M has no contract amount. Plain hyphen — see [_periodLine].
              p.contractAmountCents == null
                  ? '-'
                  : pdfMoney(p.contractAmountCents!),
              pdfMoney(p.windowBilledCents),
              _statusText(p),
            ],
            _projectFlex,
            const [false, false, true, true, false],
            statusColor: _statusColor(p.status),
          ),
      ],
    );
  }

  static const _projectFlex = [4, 2, 3, 3, 4];

  static pw.Widget _clientTotals(ClientStatement s, {required bool windowed}) {
    final suffix = windowed ? ' (in period)' : '';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pdfStatementRow('Total Billed$suffix', s.windowBilledCents, bold: true),
        pdfStatementRow('Total Paid$suffix', s.windowPaidCents, bold: true),
        pdfStatementRule(),
        pdfStatementTotalBar(
            'BALANCE OWING (COMPLETED)', s.closedBalanceOwingCents),
      ],
    );
  }

  // ── Project statement ─────────────────────────────────────────────────────

  /// One row per invoice across the project's whole history — no date window,
  /// matching the on-screen project statement exactly.
  /// [generatedAt] is passed in rather than read here so this stays pure —
  /// `ClientStatement` carries its own, but `ProjectStatement` has none.
  static Future<Uint8List> buildProjectStatement(
    ProjectStatement statement, {
    required DbCompanySetting? company,
    required DateTime generatedAt,
  }) async {
    final doc = pw.Document(
      title: 'Statement - ${statement.project.projectName}',
      author: company?.companyName,
    );

    doc.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          pageFormat: PdfPageFormat.letter,
          margin: pw.EdgeInsets.all(kPdfPageMargin),
        ),
        build: (context) => [
          _letterhead(
            company,
            'PROJECT STATEMENT',
            [
              'Project: ${statement.project.projectName}',
              'Client: ${statement.clientName}',
              'Generated: ${pdfDate(generatedAt)}',
            ],
            showPaymentAddress: _projectOwesSomething(statement),
          ),
          pw.Divider(color: kPdfAccent, height: 24),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pdfLabelledBlock('CLIENT', [statement.clientName]),
              ),
              pw.SizedBox(width: 24),
              pw.Expanded(
                child: pdfLabelledBlock('PROJECT', [
                  statement.project.projectName,
                  statement.isFixedPrice ? 'Fixed-Price' : 'Time & Materials',
                  if (statement.contractAmountCents != null)
                    'Contract: ${pdfMoney(statement.contractAmountCents!)}',
                  statement.isCompleted ? 'Completed' : 'In progress',
                ]),
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          _statusBanner(statement),
          pw.SizedBox(height: 16),
          _ledgerTable(statement),
          pw.SizedBox(height: 20),
          _projectTotals(statement),
          pw.SizedBox(height: 24),
          _footer(company),
        ],
      ),
    );

    return doc.save();
  }

  /// The project's overall position, worded exactly as the on-screen banner.
  static pw.Widget _statusBanner(ProjectStatement s) {
    final color = _statusColor(s.status);
    final detail = _statusDetail(s);
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: pw.BoxDecoration(
        border: pw.Border(left: pw.BorderSide(color: color, width: 3)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(_statusText(s),
              style: pw.TextStyle(
                  fontSize: 13, fontWeight: pw.FontWeight.bold, color: color)),
          if (detail != null)
            pw.Text(detail,
                style: const pw.TextStyle(
                    fontSize: 9, color: PdfColors.grey700)),
        ],
      ),
    );
  }

  static pw.Widget _ledgerTable(ProjectStatement s) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pdfSectionHeading('INVOICE HISTORY'),
        pw.SizedBox(height: 6),
        _tableHeader(const ['Date', 'Description', 'Amount', 'Status'],
            _ledgerFlex, const [false, false, true, false]),
        if (s.lines.isEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 6),
            child: pw.Text('No invoices on this project.', style: kPdfBody),
          )
        else
          for (final l in s.lines)
            _tableRow(
              [
                pdfLineDate(l.date),
                '${l.description}\n${l.invoiceNumber}',
                pdfMoney(l.amountCents),
                l.status == LedgerLineStatus.partial
                    ? 'PARTIAL\n${pdfMoney(l.paidCents)} received'
                    : _lineStatusLabel(l.status),
              ],
              _ledgerFlex,
              const [false, false, true, false],
              statusColor: _lineStatusColor(l.status),
            ),
      ],
    );
  }

  static const _ledgerFlex = [3, 7, 3, 4];

  /// Total Billed / Total Paid, then Balance Owing — the latter only when the
  /// project has reached a final number, mirroring the on-screen ledger.
  static pw.Widget _projectTotals(ProjectStatement s) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pdfStatementRow('Total Billed', s.windowBilledCents, bold: true),
        pdfStatementRow('Total Paid', s.windowPaidCents, bold: true),
        if (s.hasFinalBalance) ...[
          pdfStatementRule(),
          pdfStatementTotalBar('BALANCE OWING', s.balanceOwingCents),
        ],
      ],
    );
  }

  // ── Status wording (mirrors `statement_status_banner.dart`) ───────────────

  static String _statusText(ProjectStatement s) => switch (s.status) {
        ProjectStatementStatus.inProgress =>
          'Paid to date: ${pdfMoney(s.lifetimePaidCents)}',
        ProjectStatementStatus.notInvoiced => 'No invoices on this project',
        ProjectStatementStatus.paidInFull => 'Paid in Full',
        ProjectStatementStatus.balanceOwing =>
          'Balance Owing ${pdfMoney(s.balanceOwingCents)}',
      };

  static String? _statusDetail(ProjectStatement s) =>
      s.status == ProjectStatementStatus.inProgress
          ? 'project not yet complete'
          : null;

  static PdfColor _statusColor(ProjectStatementStatus status) =>
      switch (status) {
        ProjectStatementStatus.inProgress => PdfColors.blueGrey700,
        ProjectStatementStatus.notInvoiced => PdfColors.grey600,
        ProjectStatementStatus.paidInFull => kPdfPaidGreen,
        ProjectStatementStatus.balanceOwing => PdfColors.red700,
      };

  static String _lineStatusLabel(LedgerLineStatus s) => switch (s) {
        LedgerLineStatus.paid => 'PAID',
        LedgerLineStatus.partial => 'PARTIAL',
        LedgerLineStatus.outstanding => 'OUTSTANDING',
      };

  static PdfColor _lineStatusColor(LedgerLineStatus s) => switch (s) {
        LedgerLineStatus.paid => kPdfPaidGreen,
        LedgerLineStatus.partial => PdfColors.orange800,
        LedgerLineStatus.outstanding => PdfColors.red700,
      };

  // ── Shared page furniture ─────────────────────────────────────────────────

  /// Company block left, document title + meta right — the invoice letterhead
  /// with the document's own title in place of "INVOICE".
  ///
  /// The e-transfer address is appended to the right-hand block here rather than
  /// printed in the footer, matching the invoice: the footer is what gets pushed
  /// onto an overflow page, and the payment address is the one line that must
  /// stay where the client will look for it.
  ///
  /// [showPaymentAddress] is false for every client statement and, on a project
  /// statement, for one that is Paid in Full (see [_projectOwesSomething]).
  /// Unlike an invoice, which always asks for money, a statement is often just a
  /// record; a payment address on a settled account reads as a request for money
  /// that has already been paid.
  static pw.Widget _letterhead(
    DbCompanySetting? c,
    String documentTitle,
    List<String> metaLines, {
    required bool showPaymentAddress,
  }) {
    final cityLine = [
      c?.companyCity ?? '',
      '${c?.companyProvince ?? ''} ${c?.companyPostalCode ?? ''}'.trim(),
    ].where((s) => s.isNotEmpty).join(', ');

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              c?.companyName ?? '',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: kPdfAccent,
              ),
            ),
            if ((c?.companyAddress ?? '').isNotEmpty)
              pw.Text(c!.companyAddress!, style: kPdfBody),
            if (cityLine.isNotEmpty) pw.Text(cityLine, style: kPdfBody),
            if ((c?.companyPhone ?? '').isNotEmpty)
              pw.Text('Tel: ${c!.companyPhone}', style: kPdfBody),
            if ((c?.companyEmail ?? '').isNotEmpty)
              pw.Text(c!.companyEmail!, style: kPdfBody),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(documentTitle,
                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold)),
            for (final line in metaLines) pw.Text(line, style: kPdfBody),
            if (showPaymentAddress &&
                (c?.paymentEtransferEmail ?? '').trim().isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text('E-Transfer: ${c!.paymentEtransferEmail!.trim()}',
                  style: kPdfBody),
            ],
          ],
        ),
      ],
    );
  }

  /// Letterhead rule and GST registration only.
  ///
  /// A statement bills nothing, so the invoice footer's payment terms and
  /// thank-you line would be stating terms for a document that isn't asking for
  /// payment. The e-transfer address moved to the header block — see
  /// [_letterhead].
  static pw.Widget _footer(DbCompanySetting? c) {
    final gstReg = (c?.defaultTax1RegistrationNumber ?? '').trim();
    return pw.Column(
      children: [
        pw.Divider(color: kPdfAccent, height: 20),
        if (gstReg.isNotEmpty)
          pw.Center(
              child: pw.Text('GST Registration #: $gstReg', style: kPdfSmall)),
      ],
    );
  }

  // ── Table primitives ──────────────────────────────────────────────────────
  //
  // The invoice PDF is built entirely from two-column rows and needed no table,
  // so these are new here rather than shared: flex-weighted columns with a
  // ruled header, wrapping cells, and an optional colour on the status column
  // (always the last one).

  static pw.Widget _tableHeader(
    List<String> cells,
    List<int> flex,
    List<bool> rightAlign,
  ) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(color: kPdfAccent, width: 0.8)),
      ),
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < cells.length; i++)
            pw.Expanded(
              flex: flex[i],
              child: pw.Text(
                cells[i],
                style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800),
                textAlign:
                    rightAlign[i] ? pw.TextAlign.right : pw.TextAlign.left,
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _tableRow(
    List<String> cells,
    List<int> flex,
    List<bool> rightAlign, {
    PdfColor? statusColor,
  }) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < cells.length; i++)
            pw.Expanded(
              flex: flex[i],
              child: pw.Text(
                cells[i],
                style: pw.TextStyle(
                  fontSize: 9,
                  // The status column is the last one; colouring it matches the
                  // on-screen chips without needing a chip on paper.
                  color: i == cells.length - 1 ? statusColor : null,
                  fontWeight: i == cells.length - 1
                      ? pw.FontWeight.bold
                      : pw.FontWeight.normal,
                ),
                textAlign:
                    rightAlign[i] ? pw.TextAlign.right : pw.TextAlign.left,
              ),
            ),
        ],
      ),
    );
  }
}
