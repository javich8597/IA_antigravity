import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // ── Auth ──────────────────────────────────────────────
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

  // ── Transactions CRUD ─────────────────────────────────
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

  // ── Recurring Transactions ─────────────────────────────
  Future<List<Map<String, dynamic>>> fetchRecurringTransactions() async {
    final response = await _supabase
        .from('recurring_transactions')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addRecurringTransaction(Map<String, dynamic> data) async {
    await _supabase.from('recurring_transactions').insert(data);
  }

  Future<void> deleteRecurringTransaction(String id) async {
    await _supabase.from('recurring_transactions').delete().eq('id', id);
  }

  // ── Goals CRUD ─────────────────────────────────────────
  Future<List<Map<String, dynamic>>> fetchGoals() async {
    final response = await _supabase
        .from('goals')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addGoal(Map<String, dynamic> data) async {
    await _supabase.from('goals').insert(data);
  }

  Future<void> updateGoal(String id, double newAmount) async {
    await _supabase.from('goals').update({'current_amount': newAmount}).eq('id', id);
  }

  Future<void> deleteGoal(String id) async {
    await _supabase.from('goals').delete().eq('id', id);
  }
}

final supabaseService = SupabaseService();
