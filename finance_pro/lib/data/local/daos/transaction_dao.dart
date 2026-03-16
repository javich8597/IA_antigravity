import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [LocalTransactions, SyncQueue])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Future<List<LocalTransaction>> getAllTransactions() => select(localTransactions).get();
  
  Stream<List<LocalTransaction>> watchAllTransactions() => select(localTransactions).watch();

  Future<void> insertTransaction(LocalTransaction tx) async {
    await into(localTransactions).insert(tx, mode: InsertMode.insertOrReplace);
  }

  Future<void> updateTransaction(LocalTransaction tx) async {
    await update(localTransactions).replace(tx);
  }

  Future<void> deleteTransaction(String id) async {
    await (delete(localTransactions)..where((t) => t.id.equals(id))).go();
  }
}
