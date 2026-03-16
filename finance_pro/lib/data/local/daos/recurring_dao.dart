import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'recurring_dao.g.dart';

@DriftAccessor(tables: [LocalRecurring])
class RecurringDao extends DatabaseAccessor<AppDatabase> with _$RecurringDaoMixin {
  RecurringDao(AppDatabase db) : super(db);

  Future<List<LocalRecurringData>> getAllRecurring() => select(localRecurring).get();
  
  Stream<List<LocalRecurringData>> watchAllRecurring() => select(localRecurring).watch();

  Future<void> insertRecurring(LocalRecurringData rec) async {
    await into(localRecurring).insert(rec, mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteRecurring(String id) async {
    await (delete(localRecurring)..where((t) => t.id.equals(id))).go();
  }
}
