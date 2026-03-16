import '../../models/user_settings_model.dart';
import '../local/database.dart';
import '../../services/sync_service.dart';

abstract class SettingsRepository {
  Future<UserSettingsModel?> getSettings(String userId);
  Stream<UserSettingsModel?> watchSettings(String userId);
  Future<void> saveSettings(UserSettingsModel settings);
}

class OfflineFirstSettingsRepository implements SettingsRepository {
  final AppDatabase _db;
  final SyncService _sync;

  OfflineFirstSettingsRepository(this._db, this._sync);

  @override
  Future<UserSettingsModel?> getSettings(String userId) async {
    final s = await _db.settingsDao.getSettings(userId);
    if (s == null) return null;
    return _fromLocal(s);
  }

  @override
  Stream<UserSettingsModel?> watchSettings(String userId) {
    return _db.settingsDao.watchSettings(userId).map((s) => s != null ? _fromLocal(s) : null);
  }

  @override
  Future<void> saveSettings(UserSettingsModel settings) async {
    await _db.settingsDao.upsertSettings(_toLocal(settings));
    await _sync.enqueueOperation('settings', 'upsert', settings.userId, settings.toJson());
  }

  UserSettingsModel _fromLocal(LocalSetting s) {
    return UserSettingsModel(
      userId: s.userId,
      currency: s.currency,
      language: s.language,
      subscriptionTier: s.subscriptionTier,
      trialEndsAt: s.trialEndsAt,
      antExpenseThreshold: s.antExpenseThreshold,
      monthlyBudget: s.monthlyBudget,
      displayName: s.displayName,
    );
  }

  LocalSetting _toLocal(UserSettingsModel s) {
    return LocalSetting(
      userId: s.userId,
      currency: s.currency,
      language: s.language,
      subscriptionTier: s.subscriptionTier,
      trialEndsAt: s.trialEndsAt,
      antExpenseThreshold: s.antExpenseThreshold ?? 10.0,
      monthlyBudget: s.monthlyBudget,
      displayName: s.displayName,
    );
  }
}
