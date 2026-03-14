import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../services/supabase_service.dart';

// ── Transactions Provider ─────────────────────────────────
final transactionsProvider = FutureProvider<List<TransactionModel>>((ref) async {
  return await supabaseService.fetchTransactions();
});

// ── Recurring Transactions Provider ───────────────────────
final recurringProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await supabaseService.fetchRecurringTransactions();
});

// ── Goals Provider ────────────────────────────────────────
final goalsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await supabaseService.fetchGoals();
});

// ── Finance State (derived summary) ───────────────────────
class FinanceState {
  final double totalIncome;
  final double totalExpenses;
  final double balance;
  final List<TransactionModel> transactions;

  FinanceState({
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
    required this.transactions,
  });
}

final financeSummaryProvider = Provider<FinanceState>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);

  return transactionsAsync.maybeWhen(
    data: (data) {
      final income = data
          .where((t) => t.type == 'income')
          .fold(0.0, (sum, t) => sum + t.amount);
      final expenses = data
          .where((t) => t.type == 'expense')
          .fold(0.0, (sum, t) => sum + t.amount);

      return FinanceState(
        totalIncome: income,
        totalExpenses: expenses,
        balance: income - expenses,
        transactions: data,
      );
    },
    orElse: () => FinanceState(
      totalIncome: 0,
      totalExpenses: 0,
      balance: 0,
      transactions: [],
    ),
  );
});

// ── Finance Actions ───────────────────────────────────────
final financeActionsProvider = Provider((ref) => FinanceActions(ref));

class FinanceActions {
  final Ref _ref;
  FinanceActions(this._ref);

  Future<void> addTransaction(TransactionModel tx) async {
    await supabaseService.addTransaction(tx);
    _ref.invalidate(transactionsProvider);
  }

  Future<void> deleteTransaction(String id) async {
    await supabaseService.deleteTransaction(id);
    _ref.invalidate(transactionsProvider);
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> fields) async {
    await supabaseService.updateTransaction(id, fields);
    _ref.invalidate(transactionsProvider);
  }

  Future<void> addRecurringTransaction(Map<String, dynamic> data) async {
    await supabaseService.addRecurringTransaction(data);
    _ref.invalidate(recurringProvider);
  }

  Future<void> deleteRecurringTransaction(String id) async {
    await supabaseService.deleteRecurringTransaction(id);
    _ref.invalidate(recurringProvider);
  }

  Future<void> addGoal(Map<String, dynamic> data) async {
    await supabaseService.addGoal(data);
    _ref.invalidate(goalsProvider);
  }

  Future<void> updateGoal(String id, double amount) async {
    await supabaseService.updateGoal(id, amount);
    _ref.invalidate(goalsProvider);
  }

  Future<void> deleteGoal(String id) async {
    await supabaseService.deleteGoal(id);
    _ref.invalidate(goalsProvider);
  }
}
