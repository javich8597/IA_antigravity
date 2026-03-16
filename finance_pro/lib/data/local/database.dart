import 'package:drift/drift.dart';
import 'connection/connection.dart' as connection;
import 'tables.dart';
import 'daos/transaction_dao.dart';
import 'daos/recurring_dao.dart';
import 'daos/goal_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/user_category_memory_dao.dart';
import 'daos/exchange_rate_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    LocalTransactions,
    LocalRecurring,
    LocalGoals,
    LocalSettings,
    SyncQueue,
    LocalUserCategoryMemory,
    LocalExchangeRates,
  ],
  daos: [
    TransactionDao,
    RecurringDao,
    GoalDao,
    SettingsDao,
    UserCategoryMemoryDao,
    ExchangeRateDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connection.openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from <= 1) {
          await m.createTable(localUserCategoryMemory);
          await m.createTable(localExchangeRates);
        }
      },
    );
  }

  TransactionDao get transactionDao => TransactionDao(this);
  RecurringDao get recurringDao => RecurringDao(this);
  GoalDao get goalDao => GoalDao(this);
  SettingsDao get settingsDao => SettingsDao(this);
  UserCategoryMemoryDao get userCategoryMemoryDao => UserCategoryMemoryDao(this);
  ExchangeRateDao get exchangeRateDao => ExchangeRateDao(this);
}

// Singleton instance
final localDb = AppDatabase();
