import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Propagates the first error, stays loading until every input has data, then
/// runs [build].
///
/// The same helper is currently duplicated as a private `_combine` in
/// `analytics_providers.dart`, `invoice_providers.dart`, `time_entry_providers.dart`
/// and `final_invoice_providers.dart`. This file exists so the statement
/// providers don't add a fifth copy; those four are deliberately left alone
/// (migrating them is a separate change).
AsyncValue<R> combineAsync<R>(
  List<AsyncValue<Object?>> values,
  R Function() build,
) {
  for (final v in values) {
    if (v.hasError) {
      return AsyncValue.error(v.error!, v.stackTrace ?? StackTrace.current);
    }
  }
  if (values.any((v) => !v.hasValue)) return AsyncValue<R>.loading();
  return AsyncValue.data(build());
}
