import 'dart:convert';
import 'dart:io';

/// Android / desktop: build the file contents and write them into the device
/// Download folder, matching the original app's behaviour. There's no
/// cancellable dialog on this platform, so it always returns `true`.
///
/// [mimeType] is accepted for signature parity with the web implementation and
/// deliberately unused here — on a real filesystem the extension in [fileName]
/// is what identifies the file. Always written as UTF-8.
///
/// This writes only. Handing a saved report to the share sheet is the export
/// action's concern, not the file layer's — the backup path must not share.
Future<bool> exportTextFile(
  String fileName, {
  required String mimeType,
  required Future<String> Function() buildContent,
}) async {
  final content = await buildContent();
  const exportPath = '/storage/emulated/0/Download';
  final exportDir = Directory(exportPath);
  if (!await exportDir.exists()) {
    await exportDir.create(recursive: true);
  }
  final file = File('${exportDir.path}/$fileName');
  await file.writeAsString(content, encoding: utf8);
  return true;
}
