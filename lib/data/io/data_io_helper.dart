/// Platform-split file IO, ported from the original app's `data_io_helper`.
///
/// `Future<bool> exportJsonFile(suggestedName, buildJson)` writes a backup file
/// and returns whether it was written (`false` = the user cancelled a save
/// dialog). [buildJson] produces the file contents and is only invoked once a
/// destination is settled — important on web, where the save picker must open
/// synchronously from the click gesture (before any await) to satisfy the
/// browser's user-activation rule.
///   - Android / desktop (`dart:io`): the device `Download` folder.
///   - Web / PWA (`dart:js_interop`): a "save as" location chosen by the user
///     via the File System Access API, falling back to a browser download.
/// The stub throws on any platform that has neither.
export 'data_io_helper_stub.dart'
    if (dart.library.io) 'data_io_helper_mobile.dart'
    if (dart.library.js_interop) 'data_io_helper_web.dart';
