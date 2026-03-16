import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import 'finance_provider.dart';

/// Period filter for analytics
enum AnalyticsPeriod { month, quarter, year, all }

/// Monthly data point for trend charts
class MonthlyDataPoint {
  final DateTime month;
  final double income;
  final double expense;

  MonthlyDataPoint({required this.month, required this.income, required this.expense});

  double get balance => income - expense;
}

/// Category breakdown entry
class CategoryEntry {
  final String name;
  final double amount;
  final double percentage;

  CategoryEntry({required this.name, required this.amount, required this.percentage});
}

/// Holds all computed analytics data
class AnalyticsData {
  final List<MonthlyDataPoint> monthlyTrend;
  final List<CategoryEntry> categoryBreakdown;
  final double totalIncome;
  final double totalExpenses;
  final double avgMonthlyExpense;
  final double avgMonthlyIncome;

  AnalyticsData({
    required this.monthlyTrend,
    required this.categoryBreakdown,
    required this.totalIncome,
    required this.totalExpenses,
    required this.avgMonthlyExpense,
    required this.avgMonthlyIncome,
  });
}

/// State provider for the selected period
final analyticsPeriodProvider = StateProvider<AnalyticsPeriod>((ref) => AnalyticsPeriod.year);

/// Derived provider that computes analytics from transactions + selected period
final analyticsDataProvider = Provider<AnalyticsData>((ref) {
  final state = ref.watch(financeSummaryProvider);
  final period = ref.watch(analyticsPeriodProvider);

  // 1. Filter transactions by selected period
  final now = DateTime.now();
  final filteredTxs = state.transactions.where((tx) {
    switch (period) {
      case AnalyticsPeriod.month:
        return tx.date.year == now.year && tx.date.month == now.month;
      case AnalyticsPeriod.quarter:
        final quarterStart = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1);
        return tx.date.isAfter(quarterStart.subtract(const Duration(days: 1)));
      case AnalyticsPeriod.year:
        return tx.date.year == now.year;
      case AnalyticsPeriod.all:
        return true;
    }
  }).toList();

  // 2. Calculate monthly trend
  final monthMap = <String, MonthlyDataPoint>{};
  for (final tx in filteredTxs) {
    final key = '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}';
    final existing = monthMap[key];
    final inc = tx.type == 'income' ? tx.amount : 0.0;
    final exp = tx.type == 'expense' ? tx.amount : 0.0;

    if (existing != null) {
      monthMap[key] = MonthlyDataPoint(
        month: existing.month,
        income: existing.income + inc,
        expense: existing.expense + exp,
      );
    } else {
      monthMap[key] = MonthlyDataPoint(
        month: DateTime(tx.date.year, tx.date.month),
        income: inc,
        expense: exp,
      );
    }
  }

  final monthlyTrend = monthMap.values.toList()
    ..sort((a, b) => a.month.compareTo(b.month));

  // 3. Calculate category breakdown (expenses only)
  final catMap = <String, double>{};
  final totalExp = filteredTxs
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  for (final tx in filteredTxs.where((t) => t.type == 'expense')) {
    final cat = tx.category.split(' - ').first;
    catMap[cat] = (catMap[cat] ?? 0) + tx.amount;
  }

  final categoryBreakdown = catMap.entries
      .map((e) => CategoryEntry(
            name: e.key,
            amount: e.value,
            percentage: totalExp > 0 ? (e.value / totalExp * 100) : 0,
          ))
      .toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));

  // 4. Calculate totals and averages
  final totalInc = filteredTxs
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);

  final monthCount = monthlyTrend.isEmpty ? 1 : monthlyTrend.length;

  return AnalyticsData(
    monthlyTrend: monthlyTrend,
    categoryBreakdown: categoryBreakdown,
    totalIncome: totalInc,
    totalExpenses: totalExp,
    avgMonthlyExpense: totalExp / monthCount,
    avgMonthlyIncome: totalInc / monthCount,
  );
});
