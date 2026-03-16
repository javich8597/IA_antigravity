import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'goal_dao.g.dart';

@DriftAccessor(tables: [LocalGoals])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(AppDatabase db) : super(db);

  Future<List<LocalGoal>> getAllGoals() => select(localGoals).get();
  
  Stream<List<LocalGoal>> watchAllGoals() => select(localGoals).watch();

  Future<void> insertGoal(LocalGoal goal) async {
    await into(localGoals).insert(goal, mode: InsertMode.insertOrReplace);
  }

  Future<void> updateGoalAmount(String id, double currentAmount) async {
    await (update(localGoals)..where((g) => g.id.equals(id)))
        .write(LocalGoalsCompanion(currentAmount: Value(currentAmount)));
  }

  Future<void> deleteGoal(String id) async {
    await (delete(localGoals)..where((g) => g.id.equals(id))).go();
  }
}
