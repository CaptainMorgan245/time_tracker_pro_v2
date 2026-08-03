import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/local/drift/app_database.dart';
import '../providers/final_invoice_providers.dart' show FinalInvoiceStatement;
import '../providers/invoice_providers.dart' show InvoiceDetailData, InvoiceStatus;

/// Renders a print-ready invoice PDF (US Letter) from an already-assembled
/// [InvoiceDetailData] — the same view-model that backs the on-screen invoice
/// document, so the PDF mirrors what the user sees.
///
/// Aggregate document only: it prints the invoice's stored labour/materials
/// subtotals, not per-line time/material items (itemised T&M export is a
/// separate, provider-backed follow-up). Pure — no Drift/Riverpod access here;
/// everything arrives on [InvoiceDetailData]. All money on [DbInvoice]/payments
/// is integer **cents** and is formatted without re-rounding.
class InvoicePdfService {
  const InvoicePdfService._();

  static const _accent = PdfColor.fromInt(0xFFE8720C); // Dyconn orange
  static const _sectionBar = PdfColor.fromInt(0xFF2D2D2D);
  static const _voidWash = PdfColor.fromInt(0x22E53935); // translucent red
  static const _pageMargin = 40.0;

  static final _money =
      NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);
  static final _dateFmt = DateFormat('MMMM d, yyyy');
  static final _lineDateFmt = DateFormat('MMM d, yyyy');

  static const _typeLabels = {
    'progress': 'Progress Draw',
    'chargeable': 'Chargeable Extra',
    'addendum': 'Addendum',
    'deposit': 'Deposit',
    'extras': 'Time & Materials',
    'final': 'Final Invoice',
  };

  /// Cents → `$1,234.56`. Negatives render as `-$1.00`. Never re-rounds; input
  /// is already whole cents.
  static String _fmtMoney(int cents) => _money.format(cents / 100);

  static String _fmtDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final d = DateTime.tryParse(iso);
    return d == null ? '' : _dateFmt.format(d);
  }

  /// Builds the invoice PDF bytes. Safe to call for any status: voided invoices
  /// get a diagonal "VOID" watermark + notice rather than being refused.
  ///
  /// [statement] is supplied only for a `'final'` invoice — the reconciled
  /// contract statement replaces both the contract-summary and totals blocks,
  /// since it already states the contract, the prior draws and the balance this
  /// invoice bills. Passed in rather than read here so this stays pure.
  static Future<Uint8List> build(
    InvoiceDetailData data, {
    FinalInvoiceStatement? statement,
  }) async {
    final inv = data.invoice;
    final isVoid = inv.isDeleted != 0;

    final doc = pw.Document(
      title: 'Invoice ${inv.invoiceNumber}',
      author: data.company?.companyName,
    );

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.letter,
          margin: const pw.EdgeInsets.all(_pageMargin),
          buildBackground: isVoid ? (_) => _voidBackground() : null,
        ),
        build: (context) => [
          _header(data),
          pw.Divider(color: _accent, height: 24),
          if (isVoid) ...[
            _voidNotice(inv),
            pw.SizedBox(height: 12),
          ],
          _billToAndProject(data),
          pw.SizedBox(height: 16),
          if (statement == null && data.isFixedPrice) ...[
            _contractSummary(data),
            pw.SizedBox(height: 16),
          ],
          _workPerformed(inv),
          if ((inv.notes ?? '').trim().isNotEmpty) ...[
            pw.SizedBox(height: 12),
            _notes(inv),
          ],
          pw.SizedBox(height: 20),
          if (statement != null) _finalStatement(statement) else _totals(inv),
          if (data.paidCents > 0) ...[
            pw.SizedBox(height: 20),
            _payments(data),
          ],
          pw.SizedBox(height: 24),
          _footer(data),
        ],
      ),
    );

    return doc.save();
  }

  // ── Watermark ─────────────────────────────────────────────────────────────

  static pw.Widget _voidBackground() => pw.FullPage(
        ignoreMargins: true,
        child: pw.Center(
          child: pw.Transform.rotate(
            angle: 0.6, // ~34°
            child: pw.Text(
              'VOID',
              style: pw.TextStyle(
                fontSize: 150,
                fontWeight: pw.FontWeight.bold,
                color: _voidWash,
              ),
            ),
          ),
        ),
      );

  // ── Sections ──────────────────────────────────────────────────────────────

  static pw.Widget _header(InvoiceDetailData data) {
    final inv = data.invoice;
    final c = data.company;
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
                color: _accent,
              ),
            ),
            if ((c?.companyAddress ?? '').isNotEmpty)
              pw.Text(c!.companyAddress!, style: _body),
            if (cityLine.isNotEmpty) pw.Text(cityLine, style: _body),
            if ((c?.companyPhone ?? '').isNotEmpty)
              pw.Text('Tel: ${c!.companyPhone}', style: _body),
            if ((c?.companyEmail ?? '').isNotEmpty)
              pw.Text(c!.companyEmail!, style: _body),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('INVOICE',
                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text(_typeLabels[inv.invoiceType] ?? inv.invoiceType,
                style: _body),
            pw.Text('Invoice #: ${inv.invoiceNumber}', style: _body),
            pw.Text('Date: ${_fmtDate(inv.invoiceDate)}', style: _body),
            if ((inv.poNumber ?? '').trim().isNotEmpty)
              pw.Text('PO #: ${inv.poNumber!.trim()}', style: _body),
          ],
        ),
      ],
    );
  }

  static pw.Widget _voidNotice(DbInvoice inv) {
    final parts = <String>[
      if ((inv.deletedReasonCode ?? '').isNotEmpty)
        'Reason: ${inv.deletedReasonCode}',
      if ((inv.deletedDate ?? '').isNotEmpty)
        'Voided: ${_fmtDate(inv.deletedDate)}',
    ];
    return pw.Container(
      width: double.infinity,
      color: _voidWash,
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('THIS INVOICE HAS BEEN VOIDED',
              style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red800)),
          if (parts.isNotEmpty)
            pw.Text(parts.join('   •   '),
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.red800)),
        ],
      ),
    );
  }

  static pw.Widget _billToAndProject(InvoiceDetailData data) {
    final inv = data.invoice;
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: _labelledBlock('BILL TO', [
            data.clientName,
            if ((data.projectCity ?? '').isNotEmpty) data.projectCity!,
            if ((data.clientPhone ?? '').isNotEmpty) data.clientPhone!,
          ]),
        ),
        pw.SizedBox(width: 24),
        pw.Expanded(
          child: _labelledBlock('PROJECT', [
            data.projectName,
            if ((inv.projectAddress ?? '').isNotEmpty) inv.projectAddress!,
          ]),
        ),
      ],
    );
  }

  static pw.Widget _contractSummary(InvoiceDetailData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionHeading('CONTRACT SUMMARY'),
        pw.SizedBox(height: 6),
        _kv('Contract Value', _fmtMoney((data.contractValue * 100).round())),
        _kv('Previously Billed', _fmtMoney((data.totalBilled * 100).round())),
        _kv('GST Collected', _fmtMoney((data.totalGstCollected * 100).round())),
        pw.Divider(height: 8, color: PdfColors.grey400),
        _kv('Balance Remaining', _fmtMoney((data.remaining * 100).round()),
            bold: true),
      ],
    );
  }

  /// The work-performed block. Reads `workDescription` **only** — `notes` is an
  /// independent section (see [_notes]) and no longer backfills this one, so the
  /// two fields can never be confused for each other on the printed page.
  static pw.Widget _workPerformed(DbInvoice inv) => _narrativeBlock(
        'WORK PERFORMED',
        (inv.workDescription ?? '').trim().isNotEmpty
            ? inv.workDescription!
            : 'No description provided.',
      );

  /// Client-facing notes. Printed whenever `notes` is non-empty, independent of
  /// `workDescription`. `internalNotes` is deliberately absent from the PDF
  /// entirely — it is never printed.
  static pw.Widget _notes(DbInvoice inv) =>
      _narrativeBlock('NOTES', inv.notes!.trim());

  /// A headed, bordered paragraph block — shared by [_workPerformed] and [_notes]
  /// so both read identically on the page.
  static pw.Widget _narrativeBlock(String heading, String text) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionHeading(heading),
          pw.SizedBox(height: 4),
          pw.Container(
            width: double.infinity,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
            ),
            padding: const pw.EdgeInsets.all(8),
            child: pw.Paragraph(
                text: text, margin: pw.EdgeInsets.zero, style: _body),
          ),
        ],
      );

  /// Right-aligned totals block, mirroring the detail screen's `_totals()`:
  /// labour/materials only for T&M, subtotal (pre-discount), discount, taxes
  /// (each shown only when > 0), then the TOTAL DUE bar.
  static pw.Widget _totals(DbInvoice inv) {
    final isTm = inv.invoiceType == 'extras';
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 260,
        child: pw.Column(
          children: [
            if (isTm && inv.labourSubtotal > 0)
              _totalRow('Labour', _fmtMoney(inv.labourSubtotal)),
            if (isTm && inv.materialsSubtotal > 0)
              _totalRow('Materials', _fmtMoney(inv.materialsSubtotal)),
            _totalRow('Subtotal', _fmtMoney(inv.subtotal), bold: true),
            if (inv.discountAmount > 0)
              _totalRow(
                inv.discountDescription ?? 'Discount',
                '-${_fmtMoney(inv.discountAmount)}',
                color: PdfColors.red,
              ),
            if (inv.tax1Amount > 0)
              _totalRow(
                '${inv.tax1Name ?? 'GST'} (${(inv.tax1Rate ?? 0).toStringAsFixed(1)}%)',
                _fmtMoney(inv.tax1Amount),
              ),
            if (inv.tax2Amount > 0)
              _totalRow(
                '${inv.tax2Name ?? 'PST'} (${(inv.tax2Rate ?? 0).toStringAsFixed(1)}%)',
                _fmtMoney(inv.tax2Amount),
              ),
            pw.Divider(color: _accent, height: 12),
            pw.Container(
              color: _accent,
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL DUE',
                      style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white)),
                  pw.Text(_fmtMoney(inv.totalAmount),
                      style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The final invoice's client-facing contract statement: the contract, every
  /// draw already billed against it (with the date it was recorded), the credit
  /// for those draws, and the balance this invoice bills. Mirrors
  /// `FinalInvoiceStatementView` on screen.
  ///
  /// Replaces the ordinary totals block — `Balance Due` here *is* the invoice's
  /// total, so printing both would state the same number twice under two names.
  static pw.Widget _finalStatement(FinalInvoiceStatement s) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionHeading('CONTRACT STATEMENT'),
        pw.SizedBox(height: 6),
        _statementRow(
            'Project Price (excl. ${s.tax1Name})', s.contractPriceCents),
        _statementRow(s.tax1Name, s.contractGstCents),
        _statementRow('Contract Total', s.contractTotalCents, bold: true),
        pw.SizedBox(height: 12),
        for (final l in s.priorLines)
          _statementRow(l.label, l.amountCents,
              date: _lineDateFmt.format(l.date)),
        if (s.priorLines.isEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Text('No previous invoices on this contract.',
                style: _body),
          ),
        _statementRow('Total Paid to Date', -s.totalBilledToDateCents,
            bold: true),
        // Rule above the total, spanning just the amount column.
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Row(
            children: [
              pw.Expanded(child: pw.SizedBox()),
              pw.Container(
                  width: _stmtAmountWidth, height: 0.8, color: _accent),
            ],
          ),
        ),
        // Vertical padding only: horizontal padding would shift the amount
        // column off the alignment the rows above use, so the label is inset
        // individually instead.
        pw.Container(
          color: _accent,
          padding: const pw.EdgeInsets.symmetric(vertical: 6),
          child: pw.Row(
            children: [
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 8),
                  child: pw.Text('BALANCE DUE',
                      style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white)),
                ),
              ),
              pw.SizedBox(
                width: _stmtAmountWidth,
                child: pw.Text(_fmtMoney(s.balanceDueCents),
                    style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white),
                    textAlign: pw.TextAlign.right),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Two columns: label (+ its date) left, amount right-aligned in a fixed
  /// column. The amount column is the same on every row — including the BALANCE
  /// DUE bar — so the figures form one aligned column.
  ///
  /// [_stmtLabelWidth] applies only to dated rows, so their dates start at a
  /// common x instead of trailing labels of differing length.
  static const _stmtLabelWidth = 80.0;
  static const _stmtAmountWidth = 90.0;

  /// Statement row: label and date grouped left, amount right. Negative amounts
  /// print with a leading minus (the credit line).
  static pw.Widget _statementRow(String label, int cents,
      {String? date, bool bold = false}) {
    final style = pw.TextStyle(
      fontSize: 10,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
    );
    final text =
        cents < 0 ? '-${_fmtMoney(-cents)}' : _fmtMoney(cents);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          if (date != null) ...[
            pw.SizedBox(
                width: _stmtLabelWidth, child: pw.Text(label, style: style)),
            pw.Expanded(
              child: pw.Text(date,
                  style: const pw.TextStyle(
                      fontSize: 9, color: PdfColors.grey700)),
            ),
          ] else
            pw.Expanded(child: pw.Text(label, style: style)),
          pw.SizedBox(
            width: _stmtAmountWidth,
            child: pw.Text(text, style: style, textAlign: pw.TextAlign.right),
          ),
        ],
      ),
    );
  }

  /// Payments block (net-new vs v1). Amount paid is sourced from
  /// [InvoiceDetailData.paidCents] — the non-void payment sum from
  /// `paidCentsByInvoice`, the single source of truth. Balance is suppressed
  /// when the invoice reads as paid (covers the 1-cent tolerance) and when it
  /// would be negative (unclamped overpayment).
  static pw.Widget _payments(InvoiceDetailData data) {
    final inv = data.invoice;
    final paid = data.payments.where((p) => p.isVoid == 0).toList()
      ..sort((a, b) => a.paymentDate.compareTo(b.paymentDate));
    final multiple = paid.length > 1;
    final balanceCents = inv.totalAmount - data.paidCents;
    final fullyPaid = data.status == InvoiceStatus.paid;
    // Suppress on paid (1-cent tolerance) and on overpayment (negative).
    final showBalance = !fullyPaid && balanceCents > 0;

    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 260,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _sectionHeading(multiple ? 'PAYMENTS' : 'PAYMENT'),
            pw.SizedBox(height: 4),
            for (final p in paid) ...[
              _totalRow(
                [
                  _fmtDate(p.paymentDate),
                  if ((p.paymentMethod ?? '').isNotEmpty) p.paymentMethod!,
                  if ((p.paymentReference ?? '').isNotEmpty)
                    '#${p.paymentReference}',
                ].where((s) => s.isNotEmpty).join(' · '),
                _fmtMoney(p.amount),
              ),
            ],
            if (multiple) ...[
              pw.Divider(height: 8, color: PdfColors.grey400),
              _totalRow('Total Paid', _fmtMoney(data.paidCents), bold: true),
            ],
            pw.SizedBox(height: 2),
            if (fullyPaid)
              _totalRow('PAID IN FULL', '', bold: true, color: _paidGreen)
            else if (showBalance)
              _totalRow('Balance Due', _fmtMoney(balanceCents), bold: true),
          ],
        ),
      ),
    );
  }

  static pw.Widget _footer(InvoiceDetailData data) {
    final inv = data.invoice;
    final c = data.company;
    final gstReg = (inv.tax1RegistrationNumber ?? '').isNotEmpty
        ? inv.tax1RegistrationNumber
        : c?.defaultTax1RegistrationNumber;
    return pw.Column(
      children: [
        pw.Divider(color: _accent, height: 20),
        pw.Center(child: pw.Text('Thank you for your business.', style: _small)),
        pw.SizedBox(height: 3),
        pw.Center(
            child: pw.Text('Payment Terms: ${inv.terms}', style: _small)),
        if ((c?.paymentEtransferEmail ?? '').trim().isNotEmpty)
          pw.Center(
              child: pw.Text('E-Transfer: ${c!.paymentEtransferEmail}',
                  style: _small)),
        if ((gstReg ?? '').trim().isNotEmpty)
          pw.Center(
              child: pw.Text('GST Registration #: $gstReg', style: _small)),
      ],
    );
  }

  // ── Shared pieces ─────────────────────────────────────────────────────────

  static const _paidGreen = PdfColor.fromInt(0xFF2E7D32);
  static const pw.TextStyle _body = pw.TextStyle(fontSize: 10);
  static const pw.TextStyle _small = pw.TextStyle(fontSize: 9);

  static pw.Widget _sectionHeading(String text) => pw.Text(
        text,
        style: pw.TextStyle(
            fontSize: 11, fontWeight: pw.FontWeight.bold, color: _accent),
      );

  static pw.Widget _labelledBlock(String label, List<String> lines) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            color: _sectionBar,
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: pw.Text(label,
                style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white)),
          ),
          pw.SizedBox(height: 6),
          for (final l in lines) pw.Text(l, style: _body),
        ],
      );

  static pw.Widget _totalRow(String label, String amount,
      {bool bold = false, PdfColor? color}) {
    final style = pw.TextStyle(
      fontSize: 10,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: color,
    );
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.Text(amount, style: style),
        ],
      ),
    );
  }

  static pw.Widget _kv(String label, String value, {bool bold = false}) {
    final style = pw.TextStyle(
        fontSize: 10,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.Text(value, style: style),
        ],
      ),
    );
  }
}
