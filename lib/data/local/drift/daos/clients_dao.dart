import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/clients.dart';

part 'clients_dao.g.dart';

/// DAO for [Clients].
@DriftAccessor(tables: [Clients])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  ClientsDao(super.db);

  Future<List<DbClient>> getAll() => select(clients).get();

  Stream<List<DbClient>> watchAll() => select(clients).watch();

  Future<DbClient?> getById(int id) =>
      (select(clients)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertRow(ClientsCompanion entry) => into(clients).insert(entry);

  Future<bool> updateRow(ClientsCompanion entry) =>
      update(clients).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(clients)..where((t) => t.id.equals(id))).go();
}
