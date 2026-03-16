// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_category_memory_dao.dart';

// ignore_for_file: type=lint
mixin _$UserCategoryMemoryDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalUserCategoryMemoryTable get localUserCategoryMemory =>
      attachedDatabase.localUserCategoryMemory;
  $SyncQueueTable get syncQueue => attachedDatabase.syncQueue;
  UserCategoryMemoryDaoManager get managers =>
      UserCategoryMemoryDaoManager(this);
}

class UserCategoryMemoryDaoManager {
  final _$UserCategoryMemoryDaoMixin _db;
  UserCategoryMemoryDaoManager(this._db);
  $$LocalUserCategoryMemoryTableTableManager get localUserCategoryMemory =>
      $$LocalUserCategoryMemoryTableTableManager(
        _db.attachedDatabase,
        _db.localUserCategoryMemory,
      );
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db.attachedDatabase, _db.syncQueue);
}
