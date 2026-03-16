import '../models/transaction_model.dart';

enum BudgetStatus {
  good,
  warning,
  critical,
}

class BudgetReport {
  final double budgetAssigned;
  final double spent;
  final double remaining;
  final double dailyPacing;
  final double projectedTotal;
  final BudgetStatus status;

  const BudgetReport({
    required this.budgetAssigned,
    required this.spent,
    required this.remaining,
    required this.dailyPacing,
    required this.projectedTotal,
    required this.status,
  });
}

class BudgetService {
  static BudgetReport calculateDetailedBudget(double monthlyBudget, List<TransactionModel> transactions) {
    if (monthlyBudget <= 0) monthlyBudget = 1000.0; // Fail-safe fallback
    
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final currentDay = now.day;
    
    // Filter this month's expenses
    final thisMonthExpenses = transactions.where((tx) => 
      tx.type == 'expense' && 
      tx.date.year == now.year && 
      tx.date.month == now.month
    ).toList();
    
    final double spent = thisMonthExpenses.fold(0.0, (sum, tx) => sum + tx.amount);
    final double remaining = monthlyBudget - spent;
    
    // Pacing (ritmo de gasto diario)
    final double dailyPacing = spent / currentDay;
    
    // Proyección a fin de mes
    final double projectedTotal = dailyPacing * daysInMonth;
    
    BudgetStatus status = BudgetStatus.good;
    
    if (spent >= monthlyBudget || remaining < (monthlyBudget * 0.05)) { // Less than 5% left or overspent
      status = BudgetStatus.critical;
    } else if (projectedTotal > monthlyBudget) {
      status = BudgetStatus.warning;
    }
    
    return BudgetReport(
      budgetAssigned: monthlyBudget,
      spent: spent,
      remaining: remaining,
      dailyPacing: dailyPacing,
      projectedTotal: projectedTotal,
      status: status,
    );
  }
}
