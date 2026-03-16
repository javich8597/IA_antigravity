import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/transaction_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/goal_model.dart';
import '../models/user_settings_model.dart';
import 'supabase_service.dart';
import '../data/local/database.dart';

class SyncService {
  final AppDatabase _db;
  bool _isSyncing = false;

  SyncService(this._db) {
    // Listen to network changes
    Connectivity().onConnectivityChanged.listen((result) {
      if (!result.contains(ConnectivityResult.none)) {
        syncPendingOperations();
      }
    });
  }

  /// Adds an operation to the local sync queue
  Future<void> enqueueOperation(String table, String action, String recordId, Map<String, dynamic> payload) async {
    await _db.into(_db.syncQueue).insert(SyncQueueCompanion.insert(
      targetTable: table,
      action: action,
      recordId: recordId,
      payload: jsonEncode(payload),
    ));
    
    // Attempt immediate sync if online
    syncPendingOperations();
  }

  /// Processes the queue and pushes changes to Supabase
  Future<void> syncPendingOperations() async {
    if (_isSyncing) return;
    
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) return;

    _isSyncing = true;
    try {
      final pending = await (_db.select(_db.syncQueue)
        ..where((q) => q.synced.equals(false))
        ..orderBy([(q) => OrderingTerm(expression: q.id, mode: OrderingMode.asc)])
      ).get();

      for (final op in pending) {
        bool success = await _pushToServer(op);
        if (success) {
          // Mark as synced or delete from queue
          await (_db.update(_db.syncQueue)..where((q) => q.id.equals(op.id)))
              .write(const SyncQueueCompanion(synced: Value(true)));
        } else {
          // Break on first failure to maintain order (FIFO)
          break;
        }
      }
    } catch (e) {
      print('Sync Error: $e');
    } finally {
      // Cleanup synced items periodically
      await (_db.delete(_db.syncQueue)..where((q) => q.synced.equals(true))).go();
      _isSyncing = false;
    }
  }

  Future<bool> _pushToServer(SyncQueueData op) async {
    try {
      final payload = jsonDecode(op.payload);
      
      switch (op.targetTable) {
        case 'transactions':
          if (op.action == 'insert') await supabaseData.addTransaction(TransactionModel.fromJson(payload));
          if (op.action == 'update') await supabaseData.updateTransaction(op.recordId, payload);
          if (op.action == 'delete') await supabaseData.deleteTransaction(op.recordId);
          break;
        case 'recurring_transactions':
          if (op.action == 'insert') await supabaseData.addRecurringTransaction(RecurringTransactionModel.fromJson(payload));
          if (op.action == 'delete') await supabaseData.deleteRecurringTransaction(op.recordId);
          break;
        case 'goals':
          if (op.action == 'insert') await supabaseData.addGoal(GoalModel.fromJson(payload));
          if (op.action == 'update') await supabaseData.updateGoalAmount(op.recordId, (payload['current_amount'] as num).toDouble());
          if (op.action == 'delete') await supabaseData.deleteGoal(op.recordId);
          break;
        case 'settings':
          if (op.action == 'upsert') await supabaseData.upsertUserSettings(UserSettingsModel.fromJson(payload));
          break;
      }
      return true;
    } catch (e) {
      print('Failed to push op ${op.id} to server: $e');
      return false;
    }
  }
}

// Global instance
final syncService = SyncService(localDb);
