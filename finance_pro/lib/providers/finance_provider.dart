import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/goal_model.dart';
import '../models/user_settings_model.dart';
import '../models/wealth_model.dart';
import '../services/supabase_service.dart';
import '../services/budget_service.dart';
import '../services/ant_expense_detector.dart';
import 'exchange_rate_provider.dart';

// ── Transactions ──────────────────────────────────────────
class TransactionsNotifier extends AsyncNotifier<List<TransactionModel>> {
  @override
  Future<List<TransactionModel>> build() async {
    return await supabaseData.fetchTransactions();
  }

  Future<void> add(TransactionModel tx) async {
    await supabaseData.addTransaction(tx);
    ref.invalidateSelf();
  }

  Future<void> editTransaction(String id, Map<String, dynamic> fields) async {
    await supabaseData.updateTransaction(id, fields);
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await supabaseData.deleteTransaction(id);
    ref.invalidateSelf();
  }
}

final transactionsProvider =
    AsyncNotifierProvider<TransactionsNotifier, List<TransactionModel>>(
        TransactionsNotifier.new);

// ── Recurring Transactions ────────────────────────────────
class RecurringNotifier extends AsyncNotifier<List<RecurringTransactionModel>> {
  @override
  Future<List<RecurringTransactionModel>> build() async {
    return await supabaseData.fetchRecurringTransactions();
  }

  Future<void> add(RecurringTransactionModel recurring) async {
    await supabaseData.addRecurringTransaction(recurring);
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await supabaseData.deleteRecurringTransaction(id);
    ref.invalidateSelf();
  }
}

final recurringProvider =
    AsyncNotifierProvider<RecurringNotifier, List<RecurringTransactionModel>>(
        RecurringNotifier.new);

// ── Goals ─────────────────────────────────────────────────
class GoalsNotifier extends AsyncNotifier<List<GoalModel>> {
  @override
  Future<List<GoalModel>> build() async {
    return await supabaseData.fetchGoals();
  }

  Future<void> add(GoalModel goal) async {
    await supabaseData.addGoal(goal);
    ref.invalidateSelf();
  }

  Future<void> updateAmount(String id, double newAmount) async {
    await supabaseData.updateGoalAmount(id, newAmount);
    ref.invalidateSelf();
  }

  Future<void> delete(String id) async {
    await supabaseData.deleteGoal(id);
    ref.invalidateSelf();
  }
}

final goalsProvider =
    AsyncNotifierProvider<GoalsNotifier, List<GoalModel>>(GoalsNotifier.new);

// ── User Settings ─────────────────────────────────────────
class UserSettingsNotifier extends AsyncNotifier<UserSettingsModel> {
  @override
  Future<UserSettingsModel> build() async {
    final userId = supabaseAuth.currentUser?.id;
    if (userId == null) {
      return UserSettingsModel(userId: '');
    }
    final settings = await supabaseData.fetchUserSettings(userId);
    return settings ?? UserSettingsModel(userId: userId);
  }

  Future<void> save(UserSettingsModel settings) async {
    await supabaseData.upsertUserSettings(settings);
    ref.invalidateSelf();
  }
}

final userSettingsProvider =
    AsyncNotifierProvider<UserSettingsNotifier, UserSettingsModel>(
        UserSettingsNotifier.new);

// ── Wealth ────────────────────────────────────────────────
class WealthNotifier extends AsyncNotifier<WealthModel> {
  @override
  Future<WealthModel> build() async {
    final userId = supabaseAuth.currentUser?.id;
    if (userId == null) {
      return WealthModel(userId: '');
    }
    final wealth = await supabaseData.fetchWealth(userId);
    return wealth ?? WealthModel(userId: userId);
  }

  Future<void> save(WealthModel wealth) async {
    await supabaseData.upsertWealth(wealth);
    ref.invalidateSelf();
  }
}

final wealthProvider =
    AsyncNotifierProvider<WealthNotifier, WealthModel>(WealthNotifier.new);

// ── Finance Summary (derived state) ──────────────────────
class FinanceState {
  final double totalIncome;
  final double totalExpenses;
  final double balance;
  final List<TransactionModel> transactions;
  final BudgetReport? budgetReport;
  final AntExpenseReport? antExpenseReport;
  final bool hasStaleExchangeRate;

  FinanceState({
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
    required this.transactions,
    this.budgetReport,
    this.antExpenseReport,
    this.hasStaleExchangeRate = false,
  });
}

final financeSummaryProvider = Provider<FinanceState>((ref) {
  final transactionsAsync = ref.watch(transactionsProvider);
  final settingsAsync = ref.watch(userSettingsProvider);
  final ratesAsync = ref.watch(exchangeRatesProvider);

  final transactions = transactionsAsync.value ?? [];
  final settings = settingsAsync.value;
  final ratesData = ratesAsync.value;
  final ratesMap = ratesData?.rates ?? {};
  final isRatesStale = ratesData?.isStale ?? false;

  double getConvertedAmount(TransactionModel tx) {
    if (settings == null) return tx.amount;
    if (tx.currency == settings.currency) return tx.amount;
    final rate = ratesMap[tx.currency] ?? 1.0;
    return tx.amount * rate;
  }

  final income = transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + getConvertedAmount(t));
      
  final expenses = transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, t) => sum + getConvertedAmount(t));

  final budgetReport = settings != null 
    ? BudgetService.calculateDetailedBudget(settings.monthlyBudget, transactions)
    : null;

  final antExpenseReport = settings != null
    ? AntExpenseDetectorService.detect(transactions, settings)
    : null;

  return FinanceState(
    totalIncome: income,
    totalExpenses: expenses,
    balance: income - expenses,
    transactions: transactions,
    budgetReport: budgetReport,
    antExpenseReport: antExpenseReport,
    hasStaleExchangeRate: isRatesStale,
  );
});

// ── Finance Actions (legacy bridge for screens not yet migrated) ──
final financeActionsProvider = Provider((ref) => FinanceActions(ref));

class FinanceActions {
  final Ref _ref;
  FinanceActions(this._ref);

  Future<void> addTransaction(TransactionModel tx) async {
    await _ref.read(transactionsProvider.notifier).add(tx);
  }

  Future<void> deleteTransaction(String id) async {
    await _ref.read(transactionsProvider.notifier).delete(id);
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> fields) async {
    await _ref.read(transactionsProvider.notifier).editTransaction(id, fields);
  }

  Future<void> addRecurringTransaction(Map<String, dynamic> data) async {
    final model = RecurringTransactionModel.fromJson(data);
    await _ref.read(recurringProvider.notifier).add(model);
  }

  Future<void> deleteRecurringTransaction(String id) async {
    await _ref.read(recurringProvider.notifier).delete(id);
  }

  Future<void> addGoal(Map<String, dynamic> data) async {
    final model = GoalModel.fromJson(data);
    await _ref.read(goalsProvider.notifier).add(model);
  }

  Future<void> updateGoal(String id, double amount) async {
    await _ref.read(goalsProvider.notifier).updateAmount(id, amount);
  }

  Future<void> deleteGoal(String id) async {
    await _ref.read(goalsProvider.notifier).delete(id);
  }
}
