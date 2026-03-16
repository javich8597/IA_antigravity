// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_dao.dart';

// ignore_for_file: type=lint
mixin _$GoalDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalGoalsTable get localGoals => attachedDatabase.localGoals;
  GoalDaoManager get managers => GoalDaoManager(this);
}

class GoalDaoManager {
  final _$GoalDaoMixin _db;
  GoalDaoManager(this._db);
  $$LocalGoalsTableTableManager get localGoals =>
      $$LocalGoalsTableTableManager(_db.attachedDatabase, _db.localGoals);
}
