import '../models/transaction_model.dart';
import '../models/user_settings_model.dart';

class AntExpensePattern {
  final String description;
  final String category;
  final double averageAmount;
  final int count;
  final double totalAmount;

  AntExpensePattern({
    required this.description,
    required this.category,
    required this.averageAmount,
    required this.count,
    required this.totalAmount,
  });
}

class AntExpenseReport {
  final List<AntExpensePattern> patterns;
  final double totalWasted;

  AntExpenseReport(this.patterns, this.totalWasted);
}

class AntExpenseDetectorService {
  static const List<String> _excludedCategoriesStrict = [
    'Housing', 'Health', 'Transport', 'Savings', 'Investment', 'Income'
  ];

  static AntExpenseReport detect(List<TransactionModel> transactions, UserSettingsModel settings) {
    final threshold = settings.antExpenseThreshold;
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    // Filter relevant transactions: small expenses in the last 30 days, non-essential categories
    final candidates = transactions.where((tx) => 
      tx.type == 'expense' &&
      tx.date.isAfter(thirtyDaysAgo) &&
      tx.amount <= threshold &&
      !_excludedCategoriesStrict.contains(tx.category)
    ).toList();

    // Group by description (normalized)
    final Map<String, List<TransactionModel>> groups = {};
    for (final tx in candidates) {
      final key = tx.description.trim().toLowerCase();
      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(tx);
    }

    // Identify patterns (>= 3 occurrences in 30 days)
    final List<AntExpensePattern> patterns = [];
    double totalWasted = 0;

    groups.forEach((key, txs) {
      if (txs.length >= 3) {
        final total = txs.fold(0.0, (sum, t) => sum + t.amount);
        final avg = total / txs.length;
        
        patterns.add(AntExpensePattern(
          description: txs.first.description, // Use the original readable casing
          category: txs.first.category,
          averageAmount: avg,
          count: txs.length,
          totalAmount: total,
        ));
        
        totalWasted += total;
      }
    });

    // Sort by highest monetary impact
    patterns.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    return AntExpenseReport(patterns, totalWasted);
  }
}
