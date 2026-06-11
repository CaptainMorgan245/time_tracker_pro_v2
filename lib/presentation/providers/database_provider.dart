import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/drift/app_database.dart';

/// The single app-wide [AppDatabase] instance.
///
/// Everything that touches persistence (repositories, DAO providers, feature
/// providers) should depend on this rather than constructing its own database.
/// The connection is closed when the provider is disposed (app teardown, or a
/// `ProviderContainer` reset in tests).
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
