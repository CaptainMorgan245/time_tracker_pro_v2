import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which columns the user has ticked for the current report.
///
/// `null` means "whatever the report says is on by default" — the report owns
/// its defaults (`ExportColumn.defaultOn`), and this notifier only records a
/// deliberate departure from them. Storing the resolved set instead would mean
/// seeding it from a report that may not have loaded yet, and would silently
/// pin a stale set if a report's default columns ever changed.
///
/// A UI selection notifier, nothing more: it holds keys and never touches data.
class ExportColumnSelection extends Notifier<Set<String>?> {
  @override
  Set<String>? build() => null;

  /// Replaces the selection. Pass null to fall back to the report's defaults.
  void set(Set<String>? keys) => state = keys;

  /// Adds or removes one column key, starting from [defaults] when the user
  /// hasn't departed from them yet.
  ///
  /// Unticking the last remaining column is refused — a table with no columns
  /// exports an empty file, which reads as "no data" rather than "no columns".
  void toggle(String key, {required Iterable<String> defaults}) {
    final current = {...(state ?? defaults)};
    if (current.contains(key)) {
      if (current.length == 1) return;
      current.remove(key);
    } else {
      current.add(key);
    }
    state = current;
  }

  /// Back to the report's own defaults.
  void reset() => state = null;
}

final exportColumnSelectionProvider =
    NotifierProvider<ExportColumnSelection, Set<String>?>(
  ExportColumnSelection.new,
);
