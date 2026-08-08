import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// The shared look of every document this app prints — the palette, the type
/// scale, the repeated layout blocks and the money/date formatting.
///
/// Extracted from `InvoicePdfService`, which still renders exactly the same
/// output through these. It exists so the invoice PDF and the client/project
/// statement PDFs carry one letterhead by *construction* rather than by two
/// files happening to agree today.
///
/// Everything here is document chrome. Nothing knows what an invoice or a
/// statement is — the services compose these into their own page shapes.

// ---------------------------------------------------------------------------
// Palette + metrics
// ---------------------------------------------------------------------------

/// Dyconn orange — headings, rules, and the closing total bar.
const PdfColor kPdfAccent = PdfColor.fromInt(0xFFE8720C);

/// Dark bar behind a white all-caps block label (see [pdfLabelledBlock]).
const PdfColor kPdfSectionBar = PdfColor.fromInt(0xFF2D2D2D);

/// Settled/positive state, e.g. "PAID IN FULL".
const PdfColor kPdfPaidGreen = PdfColor.fromInt(0xFF2E7D32);

/// Page margin on every side, US Letter.
const double kPdfPageMargin = 40;

// ---------------------------------------------------------------------------
// Type scale
// ---------------------------------------------------------------------------

/// Ordinary document text.
const pw.TextStyle kPdfBody = pw.TextStyle(fontSize: 10);

/// Footer / fine print.
const pw.TextStyle kPdfSmall = pw.TextStyle(fontSize: 9);

// ---------------------------------------------------------------------------
// Formatting
// ---------------------------------------------------------------------------

final NumberFormat _money =
    NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);
final DateFormat _longDate = DateFormat('MMMM d, yyyy');
final DateFormat _lineDate = DateFormat('MMM d, yyyy');

/// Cents → `$1,234.56`. Negatives render as `-$1.00`. Never re-rounds; input is
/// already whole cents.
String pdfMoney(int cents) =>
    cents < 0 ? '-${_money.format(-cents / 100)}' : _money.format(cents / 100);

/// Long form, for document dates: `August 7, 2026`.
String pdfDate(DateTime d) => _longDate.format(d);

/// Long form from an ISO-8601 string; empty when absent or unparseable.
String pdfIsoDate(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  final d = DateTime.tryParse(iso);
  return d == null ? '' : _longDate.format(d);
}

/// Compact form, for table and ledger rows: `Aug 7, 2026`.
String pdfLineDate(DateTime d) => _lineDate.format(d);

// ---------------------------------------------------------------------------
// Blocks
// ---------------------------------------------------------------------------

/// Orange all-caps section heading.
pw.Widget pdfSectionHeading(String text) => pw.Text(
      text,
      style: pw.TextStyle(
          fontSize: 11, fontWeight: pw.FontWeight.bold, color: kPdfAccent),
    );

/// A dark bar carrying a white all-caps label, with [lines] beneath it.
pw.Widget pdfLabelledBlock(String label, List<String> lines) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          color: kPdfSectionBar,
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: pw.Text(label,
              style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white)),
        ),
        pw.SizedBox(height: 6),
        for (final l in lines) pw.Text(l, style: kPdfBody),
      ],
    );

/// Label left, value right, spread across the available width.
///
/// One function for what `InvoicePdfService` previously kept as two identical
/// private helpers (`_totalRow` and `_kv`) — same padding, same size, same
/// layout; only one of them accepted a colour.
pw.Widget pdfKeyValueRow(
  String label,
  String value, {
  bool bold = false,
  PdfColor? color,
}) {
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
        pw.Text(value, style: style),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// Statement rows — label (+ date) left, amount right in a fixed column
// ---------------------------------------------------------------------------

/// Applies only to dated rows, so their dates start at a common x instead of
/// trailing labels of differing length.
const double kPdfStmtLabelWidth = 80;

/// The amount column, identical on every row — including the closing bar — so
/// the figures form one aligned column down the page.
const double kPdfStmtAmountWidth = 90;

/// One statement row: label (and [date]) grouped left, amount right-aligned in
/// the fixed amount column. Negative amounts print with a leading minus.
pw.Widget pdfStatementRow(
  String label,
  int cents, {
  String? date,
  bool bold = false,
}) {
  final style = pw.TextStyle(
    fontSize: 10,
    fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
  );
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      children: [
        if (date != null) ...[
          pw.SizedBox(
              width: kPdfStmtLabelWidth, child: pw.Text(label, style: style)),
          pw.Expanded(
            child: pw.Text(date,
                style:
                    const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
          ),
        ] else
          pw.Expanded(child: pw.Text(label, style: style)),
        pw.SizedBox(
          width: kPdfStmtAmountWidth,
          child: pw.Text(pdfMoney(cents),
              style: style, textAlign: pw.TextAlign.right),
        ),
      ],
    ),
  );
}

/// Rule above a closing total, spanning just the amount column.
pw.Widget pdfStatementRule() => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.SizedBox()),
          pw.Container(
              width: kPdfStmtAmountWidth, height: 0.8, color: kPdfAccent),
        ],
      ),
    );

/// The solid orange closing bar, aligned to the same amount column as
/// [pdfStatementRow].
///
/// Vertical padding only: horizontal padding would shift the amount column off
/// the alignment the rows above use, so the label is inset individually instead.
pw.Widget pdfStatementTotalBar(String label, int cents) {
  // `final`, not `const`: pw.TextStyle's const constructor compares
  // `fontWeight != FontWeight.bold` in its initializer list, and an enum
  // comparison can't be const-evaluated. Styles that omit fontWeight can still
  // be const (a null operand is permitted) — which is why kPdfBody and
  // kPdfSmall are, and this one isn't.
  final style = pw.TextStyle(
    fontSize: 13,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.white,
  );
  return pw.Container(
    color: kPdfAccent,
    padding: const pw.EdgeInsets.symmetric(vertical: 6),
    child: pw.Row(
      children: [
        pw.Expanded(
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(left: 8),
            child: pw.Text(label, style: style),
          ),
        ),
        pw.SizedBox(
          width: kPdfStmtAmountWidth,
          child: pw.Text(pdfMoney(cents),
              style: style, textAlign: pw.TextAlign.right),
        ),
      ],
    ),
  );
}
