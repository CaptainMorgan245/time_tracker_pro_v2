import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/local/drift/app_database.dart';
import '../providers/final_invoice_providers.dart' show FinalInvoiceStatement;
import '../providers/invoice_providers.dart' show InvoiceDetailData, InvoiceStatus;
import 'pdf_theme.dart';

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

  /// Translucent red for the VOID watermark — invoice-specific, so it stays
  /// here rather than in the shared theme.
  static const _voidWash = PdfColor.fromInt(0x22E53935);

  static const _typeLabels = {
    'progress': 'Progress Draw',
    'chargeable': 'Chargeable Extra',
    'addendum': 'Addendum',
    'deposit': 'Deposit',
    'extras': 'Time & Materials',
    'final': 'Final Invoice',
  };

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
          margin: const pw.EdgeInsets.all(kPdfPageMargin),
          buildBackground: isVoid ? (_) => _voidBackground() : null,
        ),
        build: (context) => [
          _header(data),
          pw.Divider(color: kPdfAccent, height: 24),
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
            pw.Text('INVOICE',
                style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text(_typeLabels[inv.invoiceType] ?? inv.invoiceType,
                style: kPdfBody),
            pw.Text('Invoice #: ${inv.invoiceNumber}', style: kPdfBody),
            pw.Text('Date: ${pdfIsoDate(inv.invoiceDate)}', style: kPdfBody),
            if ((inv.poNumber ?? '').trim().isNotEmpty)
              pw.Text('PO #: ${inv.poNumber!.trim()}', style: kPdfBody),
            // Payment address sits here rather than in the footer: the footer is
            // the part that gets pushed onto an overflow page, and an e-transfer
            // address the client can't find is the one line that must not move.
            if ((c?.paymentEtransferEmail ?? '').trim().isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text('E-Transfer: ${c!.paymentEtransferEmail!.trim()}',
                  style: kPdfBody),
            ],
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
        'Voided: ${pdfIsoDate(inv.deletedDate)}',
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
            // Plain hyphen, not a bullet: the base-14 PDF font renders a
            // bullet as a missing-glyph box.
            pw.Text(parts.join('  -  '),
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
          child: pdfLabelledBlock('BILL TO', [
            data.clientName,
            if ((data.projectCity ?? '').isNotEmpty) data.projectCity!,
            if ((data.clientPhone ?? '').isNotEmpty) data.clientPhone!,
          ]),
        ),
        pw.SizedBox(width: 24),
        pw.Expanded(
          child: pdfLabelledBlock('PROJECT', [
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
        pdfSectionHeading('CONTRACT SUMMARY'),
        pw.SizedBox(height: 6),
        pdfKeyValueRow('Contract Value', pdfMoney((data.contractValue * 100).round())),
        pdfKeyValueRow('Previously Billed', pdfMoney((data.totalBilled * 100).round())),
        pdfKeyValueRow('GST Collected', pdfMoney((data.totalGstCollected * 100).round())),
        pw.Divider(height: 8, color: PdfColors.grey400),
        pdfKeyValueRow('Balance Remaining', pdfMoney((data.remaining * 100).round()),
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
          pdfSectionHeading(heading),
          pw.SizedBox(height: 4),
          pw.Container(
            width: double.infinity,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
            ),
            padding: const pw.EdgeInsets.all(8),
            child: pw.Paragraph(
                text: text, margin: pw.EdgeInsets.zero, style: kPdfBody),
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
              pdfKeyValueRow('Labour', pdfMoney(inv.labourSubtotal)),
            if (isTm && inv.materialsSubtotal > 0)
              pdfKeyValueRow('Materials', pdfMoney(inv.materialsSubtotal)),
            pdfKeyValueRow('Subtotal', pdfMoney(inv.subtotal), bold: true),
            if (inv.discountAmount > 0)
              pdfKeyValueRow(
                inv.discountDescription ?? 'Discount',
                '-${pdfMoney(inv.discountAmount)}',
                color: PdfColors.red,
              ),
            if (inv.tax1Amount > 0)
              pdfKeyValueRow(
                '${inv.tax1Name ?? 'GST'} (${(inv.tax1Rate ?? 0).toStringAsFixed(1)}%)',
                pdfMoney(inv.tax1Amount),
              ),
            if (inv.tax2Amount > 0)
              pdfKeyValueRow(
                '${inv.tax2Name ?? 'PST'} (${(inv.tax2Rate ?? 0).toStringAsFixed(1)}%)',
                pdfMoney(inv.tax2Amount),
              ),
            pw.Divider(color: kPdfAccent, height: 12),
            pw.Container(
              color: kPdfAccent,
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
                  pw.Text(pdfMoney(inv.totalAmount),
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
        pdfSectionHeading('CONTRACT STATEMENT'),
        pw.SizedBox(height: 6),
        pdfStatementRow(
            'Project Price (excl. ${s.tax1Name})', s.contractPriceCents),
        pdfStatementRow(s.tax1Name, s.contractGstCents),
        pdfStatementRow('Contract Total', s.contractTotalCents, bold: true),
        pw.SizedBox(height: 12),
        for (final l in s.priorLines)
          pdfStatementRow(l.label, l.amountCents,
              date: pdfLineDate(l.date)),
        if (s.priorLines.isEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Text('No previous invoices on this contract.',
                style: kPdfBody),
          ),
        pdfStatementRow('Total Paid to Date', -s.totalBilledToDateCents,
            bold: true),
        pdfStatementRule(),
        pdfStatementTotalBar('BALANCE DUE', s.balanceDueCents),
      ],
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
            pdfSectionHeading(multiple ? 'PAYMENTS' : 'PAYMENT'),
            pw.SizedBox(height: 4),
            for (final p in paid) ...[
              pdfKeyValueRow(
                [
                  pdfIsoDate(p.paymentDate),
                  if ((p.paymentMethod ?? '').isNotEmpty) p.paymentMethod!,
                  if ((p.paymentReference ?? '').isNotEmpty)
                    '#${p.paymentReference}',
                ].where((s) => s.isNotEmpty).join(' · '),
                pdfMoney(p.amount),
              ),
            ],
            if (multiple) ...[
              pw.Divider(height: 8, color: PdfColors.grey400),
              pdfKeyValueRow('Total Paid', pdfMoney(data.paidCents), bold: true),
            ],
            pw.SizedBox(height: 2),
            if (fullyPaid)
              pdfKeyValueRow('PAID IN FULL', '', bold: true, color: kPdfPaidGreen)
            else if (showBalance)
              pdfKeyValueRow('Balance Due', pdfMoney(balanceCents), bold: true),
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
        pw.Divider(color: kPdfAccent, height: 20),
        pw.Center(child: pw.Text('Thank you for your business.', style: kPdfSmall)),
        pw.SizedBox(height: 3),
        pw.Center(
            child: pw.Text('Payment Terms: ${inv.terms}', style: kPdfSmall)),
        // E-Transfer address deliberately absent — it lives in the header block
        // now (see [_header]), so it can't end up on an overflow page.
        if ((gstReg ?? '').trim().isNotEmpty)
          pw.Center(
              child: pw.Text('GST Registration #: $gstReg', style: kPdfSmall)),
      ],
    );
  }

}
