import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/drift/app_database.dart';
import 'database_provider.dart';

/// Shared reference / dropdown data used across multiple features (timer, cost
/// entry, personnel). Kept in a neutral file rather than inside any single
/// feature's provider module.

/// Reactive list of all employees. Auto-updates on any `employees` change.
final employeesStreamProvider = StreamProvider<List<DbEmployee>>((ref) {
  return ref.watch(databaseProvider).employeesDao.watchAll();
});

/// Reactive list of all cost codes. Auto-updates on any `cost_codes` change.
final costCodesStreamProvider = StreamProvider<List<DbCostCode>>((ref) {
  return ref.watch(databaseProvider).costCodesDao.watchAll();
});

/// Reactive list of all roles. Auto-updates on any `roles` change.
final rolesStreamProvider = StreamProvider<List<DbRole>>((ref) {
  return ref.watch(databaseProvider).rolesDao.watchAll();
});
