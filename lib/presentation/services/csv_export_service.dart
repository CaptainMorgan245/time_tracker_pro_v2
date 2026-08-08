import 'package:csv/csv.dart';

import '../../core/export/export_table.dart';

/// Renders an [ExportTable] as CSV text.
///
/// Pure and static — the same shape as `InvoicePdfService` /
/// `StatementPdfService` (no Drift, no Riverpod, no BuildContext): the caller
/// reads the providers, hands over a finished table, and gets a string back.
///
/// Every value is stringified here rather than handed to the converter as a
/// number, so the file's formatting is decided in exactly one place:
///   - money as bare `1234.56` — no `$`, no thousands separator, so a
///     spreadsheet reads it as a number instead of text;
///   - dates as ISO `yyyy-MM-dd`, which sorts and parses everywhere;
///   - hours to two decimals, booleans as `Yes`/`No`, nulls as blank.
///
/// Two things the original app's four hand-rolled exporters didn't do: a
/// UTF-8 BOM so Excel on Windows reads accented vendor names correctly, and a
/// formula-injection guard on free-text cells (vendor and description are user
/// input, and a value starting `=`, `+`, `-` or `@` is otherwise executed as a
/// formula on open).
class CsvExportService {
  const CsvExportService._();

  /// MIME type for the platform file-IO layer / web Blob.
  static const String mimeType = 'text/csv';

  /// Extension (no dot) for suggested file names.
  static const String fileExtension = 'csv';

  /// UTF-8 byte-order mark. Excel on Windows assumes the system codepage
  /// without it and mangles anything non-ASCII. Written as an escape because
  /// the character itself is invisible in source.
  static const String _bom = '\u{FEFF}';

  /// Characters that make Excel/Sheets treat a cell as a formula.
  static const _formulaLeaders = {'=', '+', '-', '@'};

  /// Converts [table] to CSV: a header row of column labels, one row per
  /// [ExportRow], and — when [ExportTable.totals] is non-empty — a trailing
  /// totals row.
  ///
  /// The totals row carries a value for every column present in `totals` and is
  /// blank elsewhere, except that the **first** column is labelled `TOTAL` when
  /// it has no total of its own (the usual case: the first column is a date or
  /// a name). A report that does supply a total for its first column keeps it.
  ///
  /// [withBom] defaults to true because the audience for these files is a
  /// bookkeeper opening them in Excel. Pass `false` for a parser that chokes on
  /// the marker.
  static String convert(ExportTable table, {bool withBom = true}) {
    final rows = <List<String>>[
      [for (final c in table.columns) c.label],
      for (final row in table.rows)
        [for (final c in table.columns) _format(row[c.key], c.type)],
      if (table.totals.isNotEmpty) _totalsRow(table),
    ];

    final csv = const ListToCsvConverter().convert(rows);
    return withBom ? '$_bom$csv' : csv;
  }

  static List<String> _totalsRow(ExportTable table) {
    return [
      for (var i = 0; i < table.columns.length; i++)
        if (table.totals.containsKey(table.columns[i].key))
          _format(table.totals[table.columns[i].key], table.columns[i].type)
        else if (i == 0)
          'TOTAL'
        else
          '',
    ];
  }

  /// Formats one cell per its column [type]. Deliberately tolerant of a value
  /// that doesn't match the declared type — it falls back to `toString()` so a
  /// single malformed cell degrades rather than failing the whole export.
  static String _format(Object? value, ExportCellType type) {
    if (value == null) return '';
    switch (type) {
      case ExportCellType.text:
        return _guardFormula(value.toString());
      case ExportCellType.date:
        // Local calendar date; the time component is never meaningful in these
        // reports (purchase dates and entry dates alike).
        if (value is DateTime) return value.toIso8601String().substring(0, 10);
        return _guardFormula(value.toString());
      case ExportCellType.hours:
        if (value is num) return value.toDouble().toStringAsFixed(2);
        return _guardFormula(value.toString());
      case ExportCellType.moneyCents:
        // Integer cents → bare decimal. Negatives are preserved as `-12.34`.
        if (value is int) return (value / 100).toStringAsFixed(2);
        if (value is num) return (value.toDouble() / 100).toStringAsFixed(2);
        return _guardFormula(value.toString());
      case ExportCellType.count:
        if (value is num) return value.toString();
        return _guardFormula(value.toString());
      case ExportCellType.boolean:
        if (value is bool) return value ? 'Yes' : 'No';
        return _guardFormula(value.toString());
    }
  }

  /// Neutralises spreadsheet formula injection by prefixing an apostrophe, the
  /// convention Excel and Sheets both honour as "treat this as literal text".
  /// Only free text can trigger it — numbers and ISO dates never start with one
  /// of [_formulaLeaders] in a way that matters, since they're generated here.
  static String _guardFormula(String value) {
    if (value.isEmpty) return value;
    return _formulaLeaders.contains(value[0]) ? "'$value" : value;
  }
}
