import 'dart:convert';
import 'dart:io';

/// Android / desktop: build the backup JSON and write it into the device
/// Download folder, matching the original app's behaviour. There's no
/// cancellable dialog on this platform, so it always returns `true`.
Future<bool> exportJsonFile(
  String fileName,
  Future<String> Function() buildJson,
) async {
  final json = await buildJson();
  const exportPath = '/storage/emulated/0/Download';
  final exportDir = Directory(exportPath);
  if (!await exportDir.exists()) {
    await exportDir.create(recursive: true);
  }
  final file = File('${exportDir.path}/$fileName');
  await file.writeAsString(json, encoding: utf8);
  return true;
}
