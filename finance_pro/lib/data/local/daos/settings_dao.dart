import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [LocalSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(AppDatabase db) : super(db);

  Future<LocalSetting?> getSettings(String userId) async {
    return await (select(localSettings)..where((s) => s.userId.equals(userId))).getSingleOrNull();
  }
  
  Stream<LocalSetting?> watchSettings(String userId) {
    return (select(localSettings)..where((s) => s.userId.equals(userId))).watchSingleOrNull();
  }

  Future<void> upsertSettings(LocalSetting settings) async {
    await into(localSettings).insert(settings, mode: InsertMode.insertOrReplace);
  }
}
