import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/local/daos/exchange_rate_dao.dart';

class ExchangeRateService {
  final ExchangeRateDao _dao;
  
  ExchangeRateService(this._dao);

  /// Fetches the exchange rate. Returns [rate, isStaleFallback]
  Future<(double, bool)> getRate(String baseCurrency, String targetCurrency) async {
    if (baseCurrency == targetCurrency) return (1.0, false);

    // 1. Check local cache (Valid 12h)
    final cachedRate = await _dao.getCachedRate(baseCurrency, targetCurrency);
    if (cachedRate != null) {
      return (cachedRate, false);
    }

    // 2. Fetch from API (Frankfurter - Free, no API key required)
    try {
      final url = Uri.parse('https://api.frankfurter.app/latest?from=$baseCurrency&to=$targetCurrency');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rate = (data['rates'][targetCurrency] as num).toDouble();
        
        // Save to cache
        await _dao.cacheRate(baseCurrency, targetCurrency, rate);
        // Save reverse rate implicitly to save future API calls
        await _dao.cacheRate(targetCurrency, baseCurrency, 1 / rate);
        
        return (rate, false);
      }
    } catch (e) {
      print('ExchangeRateService API Error: $e');
      // Falling back to stale data
    }

    // 3. Fallback to Stale Data (Older than 12h)
    final staleRate = await _dao.getStaleRate(baseCurrency, targetCurrency);
    if (staleRate != null) {
      return (staleRate.rate, true); // true = Data is stale
    }

    // 4. Ultimate Fallback (1:1 with warning)
    return (1.0, true);
  }
}
