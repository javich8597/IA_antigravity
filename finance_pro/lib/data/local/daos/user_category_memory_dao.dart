import 'package:drift/drift.dart';
import '../../../models/user_category_memory_model.dart';
import '../database.dart';
import '../tables.dart';

part 'user_category_memory_dao.g.dart';

@DriftAccessor(tables: [LocalUserCategoryMemory, SyncQueue])
class UserCategoryMemoryDao extends DatabaseAccessor<AppDatabase> with _$UserCategoryMemoryDaoMixin {
  UserCategoryMemoryDao(super.db);

  Future<List<UserCategoryMemoryModel>> getMemoryForUser(String userId) async {
    final query = select(localUserCategoryMemory)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm(expression: t.timesUsed, mode: OrderingMode.desc)]);

    final records = await query.get();
    return records.map((r) => UserCategoryMemoryModel(
      id: r.id,
      userId: r.userId,
      keyword: r.keyword,
      category: r.category,
      subcategory: r.subcategory,
      timesUsed: r.timesUsed,
      updatedAt: r.updatedAt,
    )).toList();
  }

  Future<UserCategoryMemoryModel?> findBestMatch(String userId, String keyword) async {
    final searchKeyword = keyword.toLowerCase().trim();
    if (searchKeyword.isEmpty) return null;

    final query = select(localUserCategoryMemory)
      ..where((t) => t.userId.equals(userId))
      // Simple direct match for MVP, a fuzzy match would be ideal in the future
      ..where((t) => t.keyword.lower().equals(searchKeyword))
      ..orderBy([(t) => OrderingTerm(expression: t.timesUsed, mode: OrderingMode.desc)]);
      
    final record = await query.getSingleOrNull();
    if (record == null) return null;

    return UserCategoryMemoryModel(
      id: record.id,
      userId: record.userId,
      keyword: record.keyword,
      category: record.category,
      subcategory: record.subcategory,
      timesUsed: record.timesUsed,
      updatedAt: record.updatedAt,
    );
  }

  Future<void> saveMemoryLocally(UserCategoryMemoryModel memory) async {
    await into(localUserCategoryMemory).insertOnConflictUpdate(
      LocalUserCategoryMemoryCompanion(
        id: Value(memory.id),
        userId: Value(memory.userId),
        keyword: Value(memory.keyword),
        category: Value(memory.category),
        subcategory: Value(memory.subcategory),
        timesUsed: Value(memory.timesUsed),
        updatedAt: Value(memory.updatedAt),
      ),
    );
  }

  Future<void> massDeleteCategory(String userId, String categoryToDelete) async {
    await (delete(localUserCategoryMemory)
      ..where((t) => t.userId.equals(userId))
      ..where((t) => t.category.equals(categoryToDelete))
    ).go();
    
    // Also delete from sync queue to avoid re-syncing deleted memories
    // Note: this is a simplification. A real app would sync the deletion.
  }
}
