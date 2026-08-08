import 'package:intl/intl.dart';

import '../../../core/export/export_table.dart';

/// Display formatting for [ExportTable] cells — the on-screen preview and
/// (later) the PDF.
///
/// Deliberately NOT shared with `CsvExportService`: the two have opposite
/// requirements. A CSV cell must be machine-readable (`1234.56`, no symbol, no
/// separators) so a spreadsheet parses it as a number; a preview cell must be
/// human-readable (`$1,234.56`). Sharing one formatter would force one of them
/// to be wrong.
///
/// Mirrors `analytics_format.dart`: the provider layer keeps money in integer
/// cents, and the cents→dollars divide happens here in the widget layer.

final NumberFormat _money =
    NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);

/// ISO in the preview too — a reconciliation is read down the Date column, and
/// `2026-06-04` sorts and scans better there than `4 Jun 2026`.
final DateFormat _date = DateFormat('yyyy-MM-dd');

/// Formats one cell for display. Blank for null, and tolerant of a value that
/// doesn't match its declared type (falls back to `toString()`), matching the
/// CSV service's behaviour so one odd cell can't blank out a row.
String formatExportCell(Object? value, ExportCellType type) {
  if (value == null) return '';
  switch (type) {
    case ExportCellType.text:
      return value.toString();
    case ExportCellType.date:
      return value is DateTime ? _date.format(value) : value.toString();
    case ExportCellType.hours:
      return value is num ? value.toDouble().toStringAsFixed(2) : value.toString();
    case ExportCellType.moneyCents:
      return value is num ? _money.format(value / 100) : value.toString();
    case ExportCellType.count:
      return value.toString();
    case ExportCellType.boolean:
      return value is bool ? (value ? 'Yes' : 'No') : value.toString();
  }
}

/// Whether a column's values should be right-aligned — numeric columns read far
/// better against a right edge when scanning for an amount.
bool isNumericColumn(ExportCellType type) {
  switch (type) {
    case ExportCellType.hours:
    case ExportCellType.moneyCents:
    case ExportCellType.count:
      return true;
    case ExportCellType.text:
    case ExportCellType.date:
    case ExportCellType.boolean:
      return false;
  }
}
