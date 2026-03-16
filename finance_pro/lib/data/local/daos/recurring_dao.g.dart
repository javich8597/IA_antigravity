// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_dao.dart';

// ignore_for_file: type=lint
mixin _$RecurringDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalRecurringTable get localRecurring => attachedDatabase.localRecurring;
  RecurringDaoManager get managers => RecurringDaoManager(this);
}

class RecurringDaoManager {
  final _$RecurringDaoMixin _db;
  RecurringDaoManager(this._db);
  $$LocalRecurringTableTableManager get localRecurring =>
      $$LocalRecurringTableTableManager(
        _db.attachedDatabase,
        _db.localRecurring,
      );
}
