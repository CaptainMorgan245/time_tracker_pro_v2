import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/worker_payments.dart';

part 'worker_payments_dao.g.dart';

/// DAO for [WorkerPayments].
@DriftAccessor(tables: [WorkerPayments])
class WorkerPaymentsDao extends DatabaseAccessor<AppDatabase>
    with _$WorkerPaymentsDaoMixin {
  WorkerPaymentsDao(super.db);

  Future<List<DbWorkerPayment>> getAll() => select(workerPayments).get();

  Stream<List<DbWorkerPayment>> watchAll() => select(workerPayments).watch();

  Future<DbWorkerPayment?> getById(int id) =>
      (select(workerPayments)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<DbWorkerPayment>> getByEmployee(int employeeId) =>
      (select(workerPayments)..where((t) => t.employeeId.equals(employeeId)))
          .get();

  Future<int> insertRow(WorkerPaymentsCompanion entry) =>
      into(workerPayments).insert(entry);

  Future<bool> updateRow(WorkerPaymentsCompanion entry) =>
      update(workerPayments).replace(entry);

  Future<int> deleteById(int id) =>
      (delete(workerPayments)..where((t) => t.id.equals(id))).go();
}
