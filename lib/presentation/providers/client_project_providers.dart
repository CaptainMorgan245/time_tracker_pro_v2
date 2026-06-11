import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/drift/app_database.dart';
import 'database_provider.dart';

/// Reactive list of all clients. Emits a new value whenever the `clients`
/// table changes (Drift `watch()`), so any widget watching it auto-refreshes.
final clientsStreamProvider = StreamProvider<List<DbClient>>((ref) {
  return ref.watch(databaseProvider).clientsDao.watchAll();
});

/// Reactive list of all projects. Auto-updates on any `projects` table change.
final projectsStreamProvider = StreamProvider<List<DbProject>>((ref) {
  return ref.watch(databaseProvider).projectsDao.watchAll();
});
