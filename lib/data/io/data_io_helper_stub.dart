/// Fallback used when neither `dart:io` nor `dart:js_interop` is available.
Future<bool> exportTextFile(
  String fileName, {
  required String mimeType,
  required Future<String> Function() buildContent,
}) {
  throw UnsupportedError('exportTextFile is not supported on this platform.');
}
