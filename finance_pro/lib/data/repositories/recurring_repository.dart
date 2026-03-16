import '../../models/recurring_transaction_model.dart';
import '../local/database.dart';
import '../../services/sync_service.dart';

abstract class RecurringRepository {
  Future<List<RecurringTransactionModel>> getRecurringTransactions();
  Stream<List<RecurringTransactionModel>> watchRecurringTransactions();
  Future<void> addRecurring(RecurringTransactionModel recurring);
  Future<void> deleteRecurring(String id);
}

class OfflineFirstRecurringRepository implements RecurringRepository {
  final AppDatabase _db;
  final SyncService _sync;

  OfflineFirstRecurringRepository(this._db, this._sync);

  @override
  Future<List<RecurringTransactionModel>> getRecurringTransactions() async {
    final list = await _db.recurringDao.getAllRecurring();
    return list.map(_fromLocal).toList();
  }

  @override
  Stream<List<RecurringTransactionModel>> watchRecurringTransactions() {
    return _db.recurringDao.watchAllRecurring().map((l) => l.map(_fromLocal).toList());
  }

  @override
  Future<void> addRecurring(RecurringTransactionModel recurring) async {
    await _db.recurringDao.insertRecurring(_toLocal(recurring));
    await _sync.enqueueOperation('recurring_transactions', 'insert', recurring.id ?? '', recurring.toJson());
  }

  @override
  Future<void> deleteRecurring(String id) async {
    await _db.recurringDao.deleteRecurring(id);
    await _sync.enqueueOperation('recurring_transactions', 'delete', id, {});
  }

  RecurringTransactionModel _fromLocal(LocalRecurringData r) {
    return RecurringTransactionModel(
      id: r.id,
      userId: r.userId,
      description: r.description,
      amount: r.amount,
      type: r.type,
      category: r.category,
      frequency: r.frequency,
      startDate: r.startDate,
      nextDate: r.nextDate,
      createdAt: r.createdAt,
    );
  }

  LocalRecurringData _toLocal(RecurringTransactionModel r) {
    return LocalRecurringData(
      id: r.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: r.userId,
      description: r.description,
      amount: r.amount,
      type: r.type,
      category: r.category,
      frequency: r.frequency,
      startDate: r.startDate,
      nextDate: r.nextDate,
      createdAt: r.createdAt ?? DateTime.now(),
    );
  }
}
