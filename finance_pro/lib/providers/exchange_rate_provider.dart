import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local/database.dart';
import '../services/exchange_rate_service.dart';
import 'finance_provider.dart';

final exchangeRateServiceProvider = Provider<ExchangeRateService>((ref) {
  return ExchangeRateService(localDb.exchangeRateDao);
});

// Provides a map of {currencyCode: rateMultiplierToBaseCurrency} and a boolean if any rate is stale
class ExchangeRateNotifier extends AsyncNotifier<({Map<String, double> rates, bool isStale})> {
  @override
  Future<({Map<String, double> rates, bool isStale})> build() async {
    return _fetchRates();
  }
  
  Future<({Map<String, double> rates, bool isStale})> _fetchRates() async {
    final settingsAsync = ref.watch(userSettingsProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    
    final settings = settingsAsync.value;
    final transactions = transactionsAsync.value ?? [];
    
    if (settings == null) return (rates: <String, double>{}, isStale: false);
    
    final baseCurrency = settings.currency;
    
    // Find all unique currencies used in transactions
    final uniqueCurrencies = transactions.map((t) => t.currency).toSet();
    uniqueCurrencies.remove(baseCurrency);
    
    final Map<String, double> rates = {baseCurrency: 1.0};
    final service = ref.read(exchangeRateServiceProvider);
    bool hasStale = false;
    
    for (final currency in uniqueCurrencies) {
      final (rate, isStale) = await service.getRate(currency, baseCurrency);
      rates[currency] = rate;
      if (isStale) hasStale = true;
    }
    
    return (rates: rates, isStale: hasStale);
  }
}

final exchangeRatesProvider = AsyncNotifierProvider<ExchangeRateNotifier, ({Map<String, double> rates, bool isStale})>(ExchangeRateNotifier.new);
