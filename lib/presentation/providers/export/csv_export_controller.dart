import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/export/export_table.dart';
import '../../../data/io/data_io_helper.dart';
import '../../services/csv_export_service.dart';

/// Drives a single "export this table as CSV" action, for any report.
///
/// Same shape as the backup module's `ExportController`: on success the value is
/// the saved file name; `null` means idle OR the user dismissed the web save
/// dialog. Every run goes through `AsyncValue.guard`, so a write failure lands
/// as an error state the screen can surface rather than an unhandled throw.
///
/// Report-agnostic on purpose — it takes a finished [ExportTable] and a file
/// name, so the labour/personnel reports reuse it as-is.
class CsvExportController extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() => null;

  /// Converts [table] to CSV and writes it to [fileName].
  ///
  /// The conversion is deliberately deferred into the `buildContent` callback:
  /// on web the platform helper must open the save picker *before* any await to
  /// satisfy the browser's user-activation rule, so nothing may run ahead of it.
  /// The table is already in memory, so this costs nothing.
  Future<void> export({
    required ExportTable table,
    required String fileName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final saved = await exportTextFile(
        fileName,
        mimeType: CsvExportService.mimeType,
        buildContent: () async => CsvExportService.convert(table),
      );
      return saved ? fileName : null;
    });
  }

  /// Returns to idle — call after showing the success/failure message so a
  /// rebuild doesn't re-announce the last export.
  void reset() => state = const AsyncValue.data(null);
}

final csvExportControllerProvider =
    AsyncNotifierProvider.autoDispose<CsvExportController, String?>(
  CsvExportController.new,
);

final DateFormat _fileDate = DateFormat('yyyy-MM-dd');
final DateFormat _fileTimestamp = DateFormat('yyyy-MM-dd_HH-mm-ss');

/// Builds a descriptive CSV file name: `expenses_2026-06-01_to_2026-06-30.csv`
/// when a period is set, else `expenses_2026-08-08_14-32-05.csv`.
///
/// The period is in the name because these files get emailed to a bookkeeper and
/// filed — "which month is this?" should be answerable without opening it.
/// [stem] is sanitised to word characters, dashes and underscores so a report
/// title can be passed straight in.
String buildCsvFileName({
  required String stem,
  DateTime? start,
  DateTime? end,
  required DateTime now,
}) {
  final safeStem = stem
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s-]'), '')
      .replaceAll(RegExp(r'\s+'), '_');
  final base = safeStem.isEmpty ? 'export' : safeStem;
  final String suffix;
  if (start != null && end != null) {
    suffix = '${_fileDate.format(start)}_to_${_fileDate.format(end)}';
  } else if (start != null) {
    suffix = 'from_${_fileDate.format(start)}';
  } else if (end != null) {
    suffix = 'to_${_fileDate.format(end)}';
  } else {
    suffix = _fileTimestamp.format(now);
  }
  return '${base}_$suffix.${CsvExportService.fileExtension}';
}
