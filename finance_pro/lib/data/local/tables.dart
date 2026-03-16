import 'package:drift/drift.dart';

// ── Transaction Table ────────────────────────────────────
class LocalTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get amount => real()();
  TextColumn get type => text().withDefault(const Constant('expense'))();
  TextColumn get category => text().withDefault(const Constant('General'))();
  TextColumn get currency => text().withDefault(const Constant('EUR'))();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isAntExpense => boolean().withDefault(const Constant(false)).named('is_ant_expense')();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Recurring Transaction Table ──────────────────────────
class LocalRecurring extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get description => text().withDefault(const Constant(''))();
  RealColumn get amount => real()();
  TextColumn get type => text().withDefault(const Constant('expense'))();
  TextColumn get category => text().withDefault(const Constant('General'))();
  TextColumn get frequency => text().withDefault(const Constant('monthly'))();
  DateTimeColumn get startDate => dateTime().nullable().named('start_date')();
  DateTimeColumn get nextDate => dateTime().nullable().named('next_date')();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Goals Table ──────────────────────────────────────────
class LocalGoals extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get name => text()();
  RealColumn get targetAmount => real().named('target_amount')();
  RealColumn get currentAmount => real().withDefault(const Constant(0)).named('current_amount')();
  RealColumn get initialAmount => real().withDefault(const Constant(0)).named('initial_amount')();
  DateTimeColumn get deadline => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

// ── User Settings (single row per user) ──────────────────
class LocalSettings extends Table {
  TextColumn get userId => text().named('user_id')();
  TextColumn get currency => text().withDefault(const Constant('EUR'))();
  TextColumn get language => text().withDefault(const Constant('es'))();
  TextColumn get subscriptionTier => text().withDefault(const Constant('free')).named('subscription_tier')();
  DateTimeColumn get trialEndsAt => dateTime().nullable().named('trial_ends_at')();
  RealColumn get antExpenseThreshold => real().withDefault(const Constant(10.0)).named('ant_expense_threshold')();
  RealColumn get monthlyBudget => real().withDefault(const Constant(1000.0)).named('monthly_budget')();
  TextColumn get displayName => text().nullable().named('display_name')();

  @override
  Set<Column> get primaryKey => {userId};
}

// ── Exchange Rates (Cache TTL 12h) ───────────────────────
class LocalExchangeRates extends Table {
  TextColumn get baseCurrency => text().named('base_currency')();
  TextColumn get targetCurrency => text().named('target_currency')();
  RealColumn get rate => real()();
  DateTimeColumn get lastUpdated => dateTime().named('last_updated')();

  @override
  Set<Column> get primaryKey => {baseCurrency, targetCurrency};
}

// ── Sync Queue (offline operations pending sync) ─────────
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get targetTable => text().named('target_table')();
  TextColumn get action => text()(); // 'insert', 'update', 'delete'
  TextColumn get recordId => text().named('record_id')(); // ID of the record
  TextColumn get payload => text()(); // JSON-encoded data
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).named('created_at')();
}

// ── AI Category Memory Table ─────────────────────────────
class LocalUserCategoryMemory extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get keyword => text()();
  TextColumn get category => text()();
  TextColumn get subcategory => text().nullable()();
  IntColumn get timesUsed => integer().withDefault(const Constant(1)).named('times_used')();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
