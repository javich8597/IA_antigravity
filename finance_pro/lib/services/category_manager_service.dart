import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/database.dart';
import '../data/local/daos/user_category_memory_dao.dart';
import 'supabase_service.dart';

final categoryManagerProvider = Provider<CategoryManagerService>((ref) {
  return CategoryManagerService(
    localDb.userCategoryMemoryDao,
  );
});

class CategoryManagerService {
  final UserCategoryMemoryDao _memoryDao;

  CategoryManagerService(this._memoryDao);

  /// Performs a mass recategorization of all transactions from one category to another.
  /// This is used when a user decides to delete or merge an existing category.
  Future<void> deleteAndReassignCategory({
    required String oldCategory,
    required String newCategory,
  }) async {
    final user = supabaseService.currentUser;
    if (user == null) return;

    // 1. Fetch all transactions for this user from Supabase
    final allTransactions = await supabaseData.fetchTransactions();
    
    final affectedTransactions = allTransactions.where((t) => t.category == oldCategory).toList();

    // 2. Update each transaction via Supabase service
    for (final tx in affectedTransactions) {
      if (tx.id != null) {
        await supabaseData.updateTransaction(tx.id!, {'category': newCategory});
      }
    }

    // 3. Clean up the AI Memory so it stops suggesting the deleted category
    await _memoryDao.massDeleteCategory(user.id, oldCategory);
  }
}
