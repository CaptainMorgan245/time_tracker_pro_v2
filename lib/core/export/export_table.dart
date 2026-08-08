/// Format-neutral tabular model shared by every export.
///
/// A report provider's only job is to produce an [ExportTable]; a renderer's
/// only job is to turn one into CSV / PDF / an on-screen table. Neither knows
/// about the other, so adding a report costs one provider and adding an output
/// format costs one renderer — the thing the original app lacked, where four
/// widgets each carried their own copy of the CSV assembly.
///
/// Pure Dart: no Flutter, no Drift, no Riverpod. Money is carried as integer
/// **cents** ([ExportCellType.moneyCents]) all the way to the renderer, which
/// decides between `1234.56` (CSV, so a spreadsheet parses it as a number) and
/// `$1,234.56` (PDF / preview). The model never formats and never divides.
library;

/// The value contract for a column's cells. A renderer switches on this to
/// decide formatting, so a report never hands over a pre-formatted string.
///
/// Expected runtime type of the corresponding [ExportRow] value:
///   - [text]       — `String?`
///   - [date]       — `DateTime?`
///   - [hours]      — `double?`
///   - [moneyCents] — `int?` (integer cents, may be negative)
///   - [count]      — `int?`
///   - [boolean]    — `bool?`
///
/// `null` always means "blank", never zero. Renderers are tolerant of a
/// mismatched type (they fall back to `toString()`) so one bad cell can't take
/// down an export, but the contract above is what reports are expected to meet.
enum ExportCellType { text, date, hours, moneyCents, count, boolean }

/// One column of an [ExportTable]: a stable [key], a human [label], and the
/// [type] that tells renderers how to format it.
///
/// [defaultOn] seeds the column picker — a report declares every column it can
/// produce and marks the ones that are on by default, which is how the original
/// app's per-subject "include these columns" checkboxes are expressed here
/// without hardcoding a separate map per report.
class ExportColumn {
  const ExportColumn({
    required this.key,
    required this.label,
    required this.type,
    this.defaultOn = true,
  });

  /// Stable identifier used to look the value up in an [ExportRow]. Never
  /// displayed — rename [label] freely without touching the report's rows.
  final String key;

  /// Column heading shown in the CSV header row, the PDF and the preview.
  final String label;

  final ExportCellType type;

  /// Whether the column is ticked when the column picker first opens.
  final bool defaultOn;
}

/// One row, keyed by [ExportColumn.key].
///
/// Keyed rather than positional on purpose: hiding a column is then a matter of
/// dropping it from [ExportTable.columns], with no index to keep in step and no
/// way for a column and its values to drift apart.
class ExportRow {
  const ExportRow(this.values);

  final Map<String, Object?> values;

  /// The value for [key], or `null` if this row doesn't carry that column.
  Object? operator [](String key) => values[key];
}

/// A complete report: what it is, its columns, its rows, and its totals.
class ExportTable {
  const ExportTable({
    required this.title,
    required this.columns,
    required this.rows,
    this.subtitle,
    this.totals = const {},
    this.generatedAt,
  });

  /// Report name, e.g. `Expenses by Project`. Used as the PDF/preview heading
  /// and as the basis for a suggested file name.
  final String title;

  /// One-line summary of the filter that produced this table, e.g.
  /// `1 Jun 2026 – 30 Jun 2026 · All projects`. Shown in the PDF header and the
  /// preview; deliberately not written into the CSV, which stays a clean grid.
  final String? subtitle;

  /// Every column this table currently carries, in display order. Already
  /// narrowed to the user's picks — see [selectColumns].
  final List<ExportColumn> columns;

  final List<ExportRow> rows;

  /// Column totals keyed by [ExportColumn.key]. Only the columns that have a
  /// meaningful total need an entry; values follow the same type contract as
  /// row values, so renderers format them identically. Empty means "no totals
  /// row".
  final Map<String, Object?> totals;

  /// When the report was built. Supplied by the caller rather than read from
  /// the clock here, keeping this model pure and the output reproducible.
  final DateTime? generatedAt;

  bool get isEmpty => rows.isEmpty;
  bool get isNotEmpty => rows.isNotEmpty;
  int get rowCount => rows.length;

  /// The keys of the columns that are on by default — the column picker's
  /// initial selection.
  List<String> get defaultColumnKeys =>
      [for (final c in columns) if (c.defaultOn) c.key];

  /// This table narrowed to [keys], preserving the order the report **declared**
  /// its columns in (not the order [keys] arrives in), so a report's layout is
  /// its own to decide and can't be scrambled by the picker.
  ///
  /// Unknown keys are ignored. Rows are reused untouched — they're keyed, so a
  /// hidden column's values simply go unread. Passing no matching key yields a
  /// column-less table; that's the caller's call to prevent (the picker should
  /// not allow emptying the selection).
  ExportTable selectColumns(Iterable<String> keys) {
    final wanted = keys.toSet();
    return ExportTable(
      title: title,
      subtitle: subtitle,
      columns: [for (final c in columns) if (wanted.contains(c.key)) c],
      rows: rows,
      totals: totals,
      generatedAt: generatedAt,
    );
  }
}
