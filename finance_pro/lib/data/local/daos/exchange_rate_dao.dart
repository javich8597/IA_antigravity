import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'exchange_rate_dao.g.dart';

@DriftAccessor(tables: [LocalExchangeRates])
class ExchangeRateDao extends DatabaseAccessor<AppDatabase> with _$ExchangeRateDaoMixin {
  ExchangeRateDao(AppDatabase db) : super(db);

  Future<double?> getCachedRate(String baseCurrency, String targetCurrency) async {
    final record = await (select(localExchangeRates)
          ..where((r) => r.baseCurrency.equals(baseCurrency) & r.targetCurrency.equals(targetCurrency)))
        .getSingleOrNull();

    if (record == null) return null;

    // Check TTL (12 hours)
    final now = DateTime.now();
    final difference = now.difference(record.lastUpdated);

    if (difference.inHours >= 12) {
      return null; // Stale cache
    }

    return record.rate;
  }
  
  // Gets rate exactly as it is, even if it's stale (for offline fallback)
  Future<LocalExchangeRate?> getStaleRate(String baseCurrency, String targetCurrency) async {
    return await (select(localExchangeRates)
          ..where((r) => r.baseCurrency.equals(baseCurrency) & r.targetCurrency.equals(targetCurrency)))
        .getSingleOrNull();
  }

  Future<void> cacheRate(String baseCurrency, String targetCurrency, double rate) async {
    await into(localExchangeRates).insert(
      LocalExchangeRate(
        baseCurrency: baseCurrency,
        targetCurrency: targetCurrency,
        rate: rate,
        lastUpdated: DateTime.now(),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
}
