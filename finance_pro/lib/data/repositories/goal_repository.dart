import '../../models/goal_model.dart';
import '../local/database.dart';
import '../../services/sync_service.dart';

abstract class GoalRepository {
  Future<List<GoalModel>> getGoals();
  Stream<List<GoalModel>> watchGoals();
  Future<void> addGoal(GoalModel goal);
  Future<void> updateGoalAmount(String id, double currentAmount);
  Future<void> deleteGoal(String id);
}

class OfflineFirstGoalRepository implements GoalRepository {
  final AppDatabase _db;
  final SyncService _sync;

  OfflineFirstGoalRepository(this._db, this._sync);

  @override
  Future<List<GoalModel>> getGoals() async {
    final localGoals = await _db.goalDao.getAllGoals();
    return localGoals.map(_fromLocal).toList();
  }

  @override
  Stream<List<GoalModel>> watchGoals() {
    return _db.goalDao.watchAllGoals().map((list) => list.map(_fromLocal).toList());
  }

  @override
  Future<void> addGoal(GoalModel goal) async {
    await _db.goalDao.insertGoal(_toLocal(goal));
    await _sync.enqueueOperation('goals', 'insert', goal.id ?? '', goal.toJson());
  }

  @override
  Future<void> updateGoalAmount(String id, double currentAmount) async {
    await _db.goalDao.updateGoalAmount(id, currentAmount);
    await _sync.enqueueOperation('goals', 'update', id, {'current_amount': currentAmount});
  }

  @override
  Future<void> deleteGoal(String id) async {
    await _db.goalDao.deleteGoal(id);
    await _sync.enqueueOperation('goals', 'delete', id, {});
  }

  GoalModel _fromLocal(LocalGoal g) {
    return GoalModel(
      id: g.id,
      userId: g.userId,
      name: g.name,
      targetAmount: g.targetAmount,
      currentAmount: g.currentAmount,
      initialAmount: g.initialAmount,
      deadline: g.deadline,
      createdAt: g.createdAt,
    );
  }

  LocalGoal _toLocal(GoalModel g) {
    return LocalGoal(
      id: g.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: g.userId,
      name: g.name,
      targetAmount: g.targetAmount,
      currentAmount: g.currentAmount,
      initialAmount: g.initialAmount,
      deadline: g.deadline,
      createdAt: g.createdAt ?? DateTime.now(),
    );
  }
}
