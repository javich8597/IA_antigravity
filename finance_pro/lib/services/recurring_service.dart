import '../models/transaction_model.dart';
import 'supabase_service.dart';

/// Service that processes recurring transactions and generates real transactions
/// for all past-due periods since the last processing date.
class RecurringService {
  /// Process all recurring transactions for the current user.
  /// Returns the number of transactions generated.
  static Future<int> processRecurringTransactions() async {
    final userId = supabaseAuth.currentUser?.id;
    if (userId == null) return 0;

    final recurrings = await supabaseData.fetchRecurringTransactions();
    final now = DateTime.now();
    int generated = 0;

    for (final rec in recurrings) {
      if (rec.nextDate == null) continue;

      DateTime nextDate = rec.nextDate!;

      // Generate transactions for each past-due period
      while (!nextDate.isAfter(now)) {
        // Create a real transaction for this period
        final tx = TransactionModel(
          userId: rec.userId,
          description: rec.description,
          amount: rec.amount,
          type: rec.type,
          category: rec.category,
          currency: rec.currency,
          date: nextDate,
        );

        await supabaseData.addTransaction(tx);
        generated++;

        // Advance to the next period
        nextDate = _advanceDate(nextDate, rec.frequency);
      }

      // Update the recurring template's next_date so we don't re-generate
      if (rec.id != null && nextDate != rec.nextDate) {
        await supabaseData.updateRecurringNextDate(
          rec.id!,
          nextDate,
        );
      }
    }

    print('RecurringService: Generated $generated transactions');
    return generated;
  }

  /// Advance a date by the given frequency
  static DateTime _advanceDate(DateTime date, String frequency) {
    switch (frequency) {
      case 'weekly':
        return date.add(const Duration(days: 7));
      case 'monthly':
        return DateTime(date.year, date.month + 1, date.day);
      case 'quarterly':
        return DateTime(date.year, date.month + 3, date.day);
      case 'biannually':
        return DateTime(date.year, date.month + 6, date.day);
      case 'annually':
        return DateTime(date.year + 1, date.month, date.day);
      default:
        return DateTime(date.year, date.month + 1, date.day);
    }
  }
}
