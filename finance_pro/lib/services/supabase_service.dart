import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';
import '../models/recurring_transaction_model.dart';
import '../models/goal_model.dart';
import '../models/user_settings_model.dart';
import '../models/wealth_model.dart';

/// Handles all Supabase authentication operations
class SupabaseAuthService {
  final _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}

/// Handles all Supabase data CRUD operations with typed models
class SupabaseDataService {
  final _supabase = Supabase.instance.client;

  // ── Transactions ────────────────────────────────────────
  Future<List<TransactionModel>> fetchTransactions() async {
    final response = await _supabase
        .from('transactions')
        .select()
        .order('date', ascending: false);
    return (response as List).map((t) => TransactionModel.fromJson(t)).toList();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await _supabase.from('transactions').insert(transaction.toJson());
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> fields) async {
    await _supabase.from('transactions').update(fields).eq('id', id);
  }

  Future<void> deleteTransaction(String id) async {
    await _supabase.from('transactions').delete().eq('id', id);
  }

  // ── Recurring Transactions ──────────────────────────────
  Future<List<RecurringTransactionModel>> fetchRecurringTransactions() async {
    final response = await _supabase
        .from('recurring_transactions')
        .select()
        .order('created_at', ascending: false);
    return (response as List)
        .map((r) => RecurringTransactionModel.fromJson(r))
        .toList();
  }

  Future<void> addRecurringTransaction(RecurringTransactionModel recurring) async {
    await _supabase.from('recurring_transactions').insert(recurring.toJson());
  }

  Future<void> deleteRecurringTransaction(String id) async {
    await _supabase.from('recurring_transactions').delete().eq('id', id);
  }

  Future<void> updateRecurringNextDate(String id, DateTime nextDate) async {
    await _supabase.from('recurring_transactions').update({
      'next_date': nextDate.toIso8601String().split('T')[0],
    }).eq('id', id);
  }

  // ── Goals ───────────────────────────────────────────────
  Future<List<GoalModel>> fetchGoals() async {
    final response = await _supabase
        .from('goals')
        .select()
        .order('created_at', ascending: false);
    return (response as List).map((g) => GoalModel.fromJson(g)).toList();
  }

  Future<void> addGoal(GoalModel goal) async {
    await _supabase.from('goals').insert(goal.toJson());
  }

  Future<void> updateGoalAmount(String id, double newAmount) async {
    await _supabase.from('goals').update({'current_amount': newAmount}).eq('id', id);
  }

  Future<void> deleteGoal(String id) async {
    await _supabase.from('goals').delete().eq('id', id);
  }

  // ── User Settings ──────────────────────────────────────
  Future<UserSettingsModel?> fetchUserSettings(String userId) async {
    final response = await _supabase
        .from('user_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (response == null) return null;
    return UserSettingsModel.fromJson(response);
  }

  Future<void> upsertUserSettings(UserSettingsModel settings) async {
    await _supabase.from('user_settings').upsert(settings.toJson());
  }

  // ── Wealth ─────────────────────────────────────────────
  Future<WealthModel?> fetchWealth(String userId) async {
    final response = await _supabase
        .from('user_wealth')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (response == null) return null;
    return WealthModel.fromJson(response);
  }

  Future<void> upsertWealth(WealthModel wealth) async {
    await _supabase.from('user_wealth').upsert(wealth.toJson());
  }
}

/// Global singleton instances
final supabaseAuth = SupabaseAuthService();
final supabaseData = SupabaseDataService();

/// Legacy compatibility — will be removed after all screens are updated
class SupabaseService {
  User? get currentUser => supabaseAuth.currentUser;
  Stream<AuthState> get authStateChanges => supabaseAuth.authStateChanges;
  Future<AuthResponse> signInWithEmail(String e, String p) => supabaseAuth.signInWithEmail(e, p);
  Future<AuthResponse> signUpWithEmail(String e, String p) => supabaseAuth.signUpWithEmail(e, p);
  Future<void> signOut() => supabaseAuth.signOut();

  Future<List<TransactionModel>> fetchTransactions() => supabaseData.fetchTransactions();
  Future<void> addTransaction(TransactionModel tx) => supabaseData.addTransaction(tx);
  Future<void> updateTransaction(String id, Map<String, dynamic> f) => supabaseData.updateTransaction(id, f);
  Future<void> deleteTransaction(String id) => supabaseData.deleteTransaction(id);

  Future<List<RecurringTransactionModel>> fetchRecurringTransactions() => supabaseData.fetchRecurringTransactions();
  Future<void> addRecurringTransaction(Map<String, dynamic> data) async {
    final model = RecurringTransactionModel.fromJson(data);
    await supabaseData.addRecurringTransaction(model);
  }
  Future<void> deleteRecurringTransaction(String id) => supabaseData.deleteRecurringTransaction(id);

  Future<List<GoalModel>> fetchGoals() => supabaseData.fetchGoals();
  Future<void> addGoal(Map<String, dynamic> data) async {
    final model = GoalModel.fromJson(data);
    await supabaseData.addGoal(model);
  }
  Future<void> updateGoal(String id, double amount) => supabaseData.updateGoalAmount(id, amount);
  Future<void> deleteGoal(String id) => supabaseData.deleteGoal(id);
}

final supabaseService = SupabaseService();
