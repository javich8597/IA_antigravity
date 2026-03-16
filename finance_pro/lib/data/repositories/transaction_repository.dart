import '../../models/transaction_model.dart';
import '../local/database.dart';
import '../../services/sync_service.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> getTransactions();
  Stream<List<TransactionModel>> watchTransactions();
  Future<void> addTransaction(TransactionModel tx);
  Future<void> updateTransaction(TransactionModel tx);
  Future<void> deleteTransaction(String id);
}

class OfflineFirstTransactionRepository implements TransactionRepository {
  final AppDatabase _db;
  final SyncService _sync;

  OfflineFirstTransactionRepository(this._db, this._sync);

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final localTxs = await _db.transactionDao.getAllTransactions();
    return localTxs.map(_fromLocal).toList();
  }

  @override
  Stream<List<TransactionModel>> watchTransactions() {
    return _db.transactionDao.watchAllTransactions().map((list) =>
        list.map(_fromLocal).toList());
  }

  @override
  Future<void> addTransaction(TransactionModel tx) async {
    // 1. Write to local database instantly
    await _db.transactionDao.insertTransaction(_toLocal(tx));
    // 2. Enqueue for remote sync
    await _sync.enqueueOperation('transactions', 'insert', tx.id ?? '', tx.toJson());
  }

  @override
  Future<void> updateTransaction(TransactionModel tx) async {
    await _db.transactionDao.updateTransaction(_toLocal(tx));
    await _sync.enqueueOperation('transactions', 'update', tx.id ?? '', tx.toJson());
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _db.transactionDao.deleteTransaction(id);
    await _sync.enqueueOperation('transactions', 'delete', id, {});
  }

  // Mappers
  TransactionModel _fromLocal(LocalTransaction t) {
    return TransactionModel(
      id: t.id,
      userId: t.userId,
      description: t.description,
      amount: t.amount,
      type: t.type,
      category: t.category,
      currency: t.currency,
      isAntExpense: t.isAntExpense,
      date: t.date,
    );
  }

  LocalTransaction _toLocal(TransactionModel t) {
    return LocalTransaction(
      id: t.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: t.userId,
      description: t.description,
      amount: t.amount,
      type: t.type,
      category: t.category,
      currency: t.currency, // Uses model's currency field
      date: t.date,
      isAntExpense: false,
      createdAt: DateTime.now(),
    );
  }
}
