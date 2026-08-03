/// Fallback used when neither `dart:io` nor `dart:js_interop` is available.
Future<bool> exportJsonFile(
  String fileName,
  Future<String> Function() buildJson,
) {
  throw UnsupportedError('exportJsonFile is not supported on this platform.');
}
