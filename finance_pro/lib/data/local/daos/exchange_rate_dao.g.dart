// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_dao.dart';

// ignore_for_file: type=lint
mixin _$ExchangeRateDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalExchangeRatesTable get localExchangeRates =>
      attachedDatabase.localExchangeRates;
  ExchangeRateDaoManager get managers => ExchangeRateDaoManager(this);
}

class ExchangeRateDaoManager {
  final _$ExchangeRateDaoMixin _db;
  ExchangeRateDaoManager(this._db);
  $$LocalExchangeRatesTableTableManager get localExchangeRates =>
      $$LocalExchangeRatesTableTableManager(
        _db.attachedDatabase,
        _db.localExchangeRates,
      );
}
