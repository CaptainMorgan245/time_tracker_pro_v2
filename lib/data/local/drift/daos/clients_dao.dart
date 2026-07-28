import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/clients.dart';

part 'clients_dao.g.dart';

/// DAO for [Clients].
@DriftAccessor(tables: [Clients])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  ClientsDao(super.db);

  /// Ordered by name, case-insensitively — see [_byName]. Every picker and list
  /// in the app inherits this, so alphabetical order is a property of "the list
  /// of clients" rather than something each screen has to remember.
  Future<List<DbClient>> getAll() => _byName().get();

  Stream<List<DbClient>> watchAll() => _byName().watch();

  /// `SELECT … ORDER BY name COLLATE NOCASE`. Case-insensitive because plain
  /// `compareTo`/binary collation sorts every capital ahead of every lowercase
  /// letter, which put "Zenith" before "acme".
  SimpleSelectStatement<$ClientsTable, DbClient> _byName() => select(clients)
    ..orderBy([(t) => OrderingTerm(expression: t.name.collate(Collate.noCase))]);

  Future<DbClient?> getById(int id) =>
      (select(clients)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertRow(ClientsCompanion entry) => into(clients).insert(entry);

  Future<bool> updateRow(ClientsCompanion entry) =>
      update(clients).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(clients)..where((t) => t.id.equals(id))).go();
}
