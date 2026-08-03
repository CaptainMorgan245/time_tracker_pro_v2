import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

/// Web / PWA backup export.
///
/// Where supported (Chromium desktop / installed PWA, secure context), uses the
/// File System Access API (`window.showSaveFilePicker`) so the user chooses the
/// save location. That call MUST run synchronously inside the click gesture —
/// before any `await` — or the browser blocks it for lack of user activation.
/// So the picker is invoked first, and [buildJson] (async DB work) only runs
/// *after* a location is chosen. `showSaveFilePicker` isn't in package:web's
/// typed bindings, so it's called via js_interop_unsafe; the returned
/// handle/stream use the typed API.
///
/// The write is confirmed: `write` + `close` must resolve, and the file is read
/// back and checked to be non-empty. Any failure throws (surfaced as an error)
/// rather than reporting a false success. Returns `true` on a confirmed save,
/// `false` only if the user dismissed the picker.
///
/// Falls back to a plain browser download where the API is unavailable
/// (Firefox/Safari, or a non-secure context).
Future<bool> exportJsonFile(
  String suggestedName,
  Future<String> Function() buildJson,
) async {
  final win = window as JSObject;
  if (win.has('showSaveFilePicker')) {
    final FileSystemFileHandle handle;
    try {
      final options = JSObject()
        ..setProperty('suggestedName'.toJS, suggestedName.toJS);
      // First thing after the gesture — no await before this call.
      final picked = await win
          .callMethod<JSPromise<JSAny?>>('showSaveFilePicker'.toJS, options)
          .toDart;
      handle = picked as FileSystemFileHandle;
    } catch (e) {
      if (_isAbortError(e)) return false; // user dismissed the picker
      rethrow; // a real picker failure — surface it
    }

    final json = await buildJson();
    final blob = Blob(
      [json.toJS].toJS,
      BlobPropertyBag(type: 'application/json'),
    );

    final writable = await handle.createWritable().toDart;
    try {
      await writable.write(blob).toDart;
    } finally {
      // Always close the stream; close() also commits/flushes the write.
      await writable.close().toDart;
    }

    // Confirm the write actually landed: read the file back and check its size.
    final written = await handle.getFile().toDart;
    if (written.size <= 0) {
      throw const _ExportException(
          'The file was created but is empty — nothing was written.');
    }
    return true;
  }

  // Fallback: no File System Access API. Generate, then download to the
  // browser's default location. The anchor is attached to the DOM so the
  // programmatic click reliably triggers the download.
  final json = await buildJson();
  _triggerDownload(suggestedName, json);
  return true;
}

void _triggerDownload(String fileName, String json) {
  final blob = Blob(
    [json.toJS].toJS,
    BlobPropertyBag(type: 'application/json'),
  );
  final url = URL.createObjectURL(blob);
  final anchor = document.createElement('a') as HTMLAnchorElement
    ..href = url
    ..download = fileName;
  document.body!.appendChild(anchor);
  anchor.click();
  anchor.remove();
  URL.revokeObjectURL(url);
}

/// True if [error] is a JS `AbortError` (the user dismissed the save dialog).
/// Defensive: any non-JS / unreadable error is treated as a real failure.
bool _isAbortError(Object error) {
  try {
    final name = (error as JSObject).getProperty<JSString>('name'.toJS).toDart;
    return name == 'AbortError';
  } catch (_) {
    return false;
  }
}

class _ExportException implements Exception {
  const _ExportException(this.message);
  final String message;
  @override
  String toString() => message;
}
