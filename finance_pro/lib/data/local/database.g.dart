// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocalTransactionsTable extends LocalTransactions
    with TableInfo<$LocalTransactionsTable, LocalTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('expense'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAntExpenseMeta = const VerificationMeta(
    'isAntExpense',
  );
  @override
  late final GeneratedColumn<bool> isAntExpense = GeneratedColumn<bool>(
    'is_ant_expense',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ant_expense" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    description,
    amount,
    type,
    category,
    currency,
    date,
    isAntExpense,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_ant_expense')) {
      context.handle(
        _isAntExpenseMeta,
        isAntExpense.isAcceptableOrUnknown(
          data['is_ant_expense']!,
          _isAntExpenseMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isAntExpense: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ant_expense'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $LocalTransactionsTable createAlias(String alias) {
    return $LocalTransactionsTable(attachedDatabase, alias);
  }
}

class LocalTransaction extends DataClass
    implements Insertable<LocalTransaction> {
  final String id;
  final String userId;
  final String description;
  final double amount;
  final String type;
  final String category;
  final String currency;
  final DateTime date;
  final bool isAntExpense;
  final DateTime? createdAt;
  const LocalTransaction({
    required this.id,
    required this.userId,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.currency,
    required this.date,
    required this.isAntExpense,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['currency'] = Variable<String>(currency);
    map['date'] = Variable<DateTime>(date);
    map['is_ant_expense'] = Variable<bool>(isAntExpense);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  LocalTransactionsCompanion toCompanion(bool nullToAbsent) {
    return LocalTransactionsCompanion(
      id: Value(id),
      userId: Value(userId),
      description: Value(description),
      amount: Value(amount),
      type: Value(type),
      category: Value(category),
      currency: Value(currency),
      date: Value(date),
      isAntExpense: Value(isAntExpense),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory LocalTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalTransaction(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      currency: serializer.fromJson<String>(json['currency']),
      date: serializer.fromJson<DateTime>(json['date']),
      isAntExpense: serializer.fromJson<bool>(json['isAntExpense']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'currency': serializer.toJson<String>(currency),
      'date': serializer.toJson<DateTime>(date),
      'isAntExpense': serializer.toJson<bool>(isAntExpense),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  LocalTransaction copyWith({
    String? id,
    String? userId,
    String? description,
    double? amount,
    String? type,
    String? category,
    String? currency,
    DateTime? date,
    bool? isAntExpense,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => LocalTransaction(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    category: category ?? this.category,
    currency: currency ?? this.currency,
    date: date ?? this.date,
    isAntExpense: isAntExpense ?? this.isAntExpense,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  LocalTransaction copyWithCompanion(LocalTransactionsCompanion data) {
    return LocalTransaction(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      currency: data.currency.present ? data.currency.value : this.currency,
      date: data.date.present ? data.date.value : this.date,
      isAntExpense: data.isAntExpense.present
          ? data.isAntExpense.value
          : this.isAntExpense,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransaction(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('currency: $currency, ')
          ..write('date: $date, ')
          ..write('isAntExpense: $isAntExpense, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    description,
    amount,
    type,
    category,
    currency,
    date,
    isAntExpense,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalTransaction &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.category == this.category &&
          other.currency == this.currency &&
          other.date == this.date &&
          other.isAntExpense == this.isAntExpense &&
          other.createdAt == this.createdAt);
}

class LocalTransactionsCompanion extends UpdateCompanion<LocalTransaction> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> description;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> category;
  final Value<String> currency;
  final Value<DateTime> date;
  final Value<bool> isAntExpense;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const LocalTransactionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.currency = const Value.absent(),
    this.date = const Value.absent(),
    this.isAntExpense = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalTransactionsCompanion.insert({
    required String id,
    required String userId,
    this.description = const Value.absent(),
    required double amount,
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.currency = const Value.absent(),
    required DateTime date,
    this.isAntExpense = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       amount = Value(amount),
       date = Value(date);
  static Insertable<LocalTransaction> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? currency,
    Expression<DateTime>? date,
    Expression<bool>? isAntExpense,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (currency != null) 'currency': currency,
      if (date != null) 'date': date,
      if (isAntExpense != null) 'is_ant_expense': isAntExpense,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? description,
    Value<double>? amount,
    Value<String>? type,
    Value<String>? category,
    Value<String>? currency,
    Value<DateTime>? date,
    Value<bool>? isAntExpense,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalTransactionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      isAntExpense: isAntExpense ?? this.isAntExpense,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isAntExpense.present) {
      map['is_ant_expense'] = Variable<bool>(isAntExpense.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('currency: $currency, ')
          ..write('date: $date, ')
          ..write('isAntExpense: $isAntExpense, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalRecurringTable extends LocalRecurring
    with TableInfo<$LocalRecurringTable, LocalRecurringData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalRecurringTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('expense'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextDateMeta = const VerificationMeta(
    'nextDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextDate = GeneratedColumn<DateTime>(
    'next_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    description,
    amount,
    type,
    category,
    frequency,
    startDate,
    nextDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_recurring';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalRecurringData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('next_date')) {
      context.handle(
        _nextDateMeta,
        nextDate.isAcceptableOrUnknown(data['next_date']!, _nextDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalRecurringData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalRecurringData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      nextDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $LocalRecurringTable createAlias(String alias) {
    return $LocalRecurringTable(attachedDatabase, alias);
  }
}

class LocalRecurringData extends DataClass
    implements Insertable<LocalRecurringData> {
  final String id;
  final String userId;
  final String description;
  final double amount;
  final String type;
  final String category;
  final String frequency;
  final DateTime? startDate;
  final DateTime? nextDate;
  final DateTime? createdAt;
  const LocalRecurringData({
    required this.id,
    required this.userId,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.frequency,
    this.startDate,
    this.nextDate,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || nextDate != null) {
      map['next_date'] = Variable<DateTime>(nextDate);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  LocalRecurringCompanion toCompanion(bool nullToAbsent) {
    return LocalRecurringCompanion(
      id: Value(id),
      userId: Value(userId),
      description: Value(description),
      amount: Value(amount),
      type: Value(type),
      category: Value(category),
      frequency: Value(frequency),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      nextDate: nextDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDate),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory LocalRecurringData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalRecurringData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      frequency: serializer.fromJson<String>(json['frequency']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      nextDate: serializer.fromJson<DateTime?>(json['nextDate']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'frequency': serializer.toJson<String>(frequency),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'nextDate': serializer.toJson<DateTime?>(nextDate),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  LocalRecurringData copyWith({
    String? id,
    String? userId,
    String? description,
    double? amount,
    String? type,
    String? category,
    String? frequency,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> nextDate = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => LocalRecurringData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    category: category ?? this.category,
    frequency: frequency ?? this.frequency,
    startDate: startDate.present ? startDate.value : this.startDate,
    nextDate: nextDate.present ? nextDate.value : this.nextDate,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  LocalRecurringData copyWithCompanion(LocalRecurringCompanion data) {
    return LocalRecurringData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextDate: data.nextDate.present ? data.nextDate.value : this.nextDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalRecurringData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextDate: $nextDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    description,
    amount,
    type,
    category,
    frequency,
    startDate,
    nextDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalRecurringData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.category == this.category &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.nextDate == this.nextDate &&
          other.createdAt == this.createdAt);
}

class LocalRecurringCompanion extends UpdateCompanion<LocalRecurringData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> description;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> category;
  final Value<String> frequency;
  final Value<DateTime?> startDate;
  final Value<DateTime?> nextDate;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const LocalRecurringCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalRecurringCompanion.insert({
    required String id,
    required String userId,
    this.description = const Value.absent(),
    required double amount,
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       amount = Value(amount);
  static Insertable<LocalRecurringData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? frequency,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (nextDate != null) 'next_date': nextDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalRecurringCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? description,
    Value<double>? amount,
    Value<String>? type,
    Value<String>? category,
    Value<String>? frequency,
    Value<DateTime?>? startDate,
    Value<DateTime?>? nextDate,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalRecurringCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextDate: nextDate ?? this.nextDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextDate.present) {
      map['next_date'] = Variable<DateTime>(nextDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalRecurringCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextDate: $nextDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalGoalsTable extends LocalGoals
    with TableInfo<$LocalGoalsTable, LocalGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentAmountMeta = const VerificationMeta(
    'currentAmount',
  );
  @override
  late final GeneratedColumn<double> currentAmount = GeneratedColumn<double>(
    'current_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _initialAmountMeta = const VerificationMeta(
    'initialAmount',
  );
  @override
  late final GeneratedColumn<double> initialAmount = GeneratedColumn<double>(
    'initial_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    targetAmount,
    currentAmount,
    initialAmount,
    deadline,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
        _currentAmountMeta,
        currentAmount.isAcceptableOrUnknown(
          data['current_amount']!,
          _currentAmountMeta,
        ),
      );
    }
    if (data.containsKey('initial_amount')) {
      context.handle(
        _initialAmountMeta,
        initialAmount.isAcceptableOrUnknown(
          data['initial_amount']!,
          _initialAmountMeta,
        ),
      );
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_amount'],
      )!,
      currentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_amount'],
      )!,
      initialAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}initial_amount'],
      )!,
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $LocalGoalsTable createAlias(String alias) {
    return $LocalGoalsTable(attachedDatabase, alias);
  }
}

class LocalGoal extends DataClass implements Insertable<LocalGoal> {
  final String id;
  final String userId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final double initialAmount;
  final DateTime? deadline;
  final DateTime? createdAt;
  const LocalGoal({
    required this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.initialAmount,
    this.deadline,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['target_amount'] = Variable<double>(targetAmount);
    map['current_amount'] = Variable<double>(currentAmount);
    map['initial_amount'] = Variable<double>(initialAmount);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  LocalGoalsCompanion toCompanion(bool nullToAbsent) {
    return LocalGoalsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      initialAmount: Value(initialAmount),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory LocalGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalGoal(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      initialAmount: serializer.fromJson<double>(json['initialAmount']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'initialAmount': serializer.toJson<double>(initialAmount),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  LocalGoal copyWith({
    String? id,
    String? userId,
    String? name,
    double? targetAmount,
    double? currentAmount,
    double? initialAmount,
    Value<DateTime?> deadline = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => LocalGoal(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    targetAmount: targetAmount ?? this.targetAmount,
    currentAmount: currentAmount ?? this.currentAmount,
    initialAmount: initialAmount ?? this.initialAmount,
    deadline: deadline.present ? deadline.value : this.deadline,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  LocalGoal copyWithCompanion(LocalGoalsCompanion data) {
    return LocalGoal(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      initialAmount: data.initialAmount.present
          ? data.initialAmount.value
          : this.initialAmount,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalGoal(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('initialAmount: $initialAmount, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    targetAmount,
    currentAmount,
    initialAmount,
    deadline,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalGoal &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.initialAmount == this.initialAmount &&
          other.deadline == this.deadline &&
          other.createdAt == this.createdAt);
}

class LocalGoalsCompanion extends UpdateCompanion<LocalGoal> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<double> targetAmount;
  final Value<double> currentAmount;
  final Value<double> initialAmount;
  final Value<DateTime?> deadline;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const LocalGoalsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.initialAmount = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalGoalsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required double targetAmount,
    this.currentAmount = const Value.absent(),
    this.initialAmount = const Value.absent(),
    this.deadline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       targetAmount = Value(targetAmount);
  static Insertable<LocalGoal> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<double>? targetAmount,
    Expression<double>? currentAmount,
    Expression<double>? initialAmount,
    Expression<DateTime>? deadline,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (initialAmount != null) 'initial_amount': initialAmount,
      if (deadline != null) 'deadline': deadline,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalGoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<double>? targetAmount,
    Value<double>? currentAmount,
    Value<double>? initialAmount,
    Value<DateTime?>? deadline,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalGoalsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      initialAmount: initialAmount ?? this.initialAmount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<double>(currentAmount.value);
    }
    if (initialAmount.present) {
      map['initial_amount'] = Variable<double>(initialAmount.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalGoalsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('initialAmount: $initialAmount, ')
          ..write('deadline: $deadline, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSettingsTable extends LocalSettings
    with TableInfo<$LocalSettingsTable, LocalSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('es'),
  );
  static const VerificationMeta _subscriptionTierMeta = const VerificationMeta(
    'subscriptionTier',
  );
  @override
  late final GeneratedColumn<String> subscriptionTier = GeneratedColumn<String>(
    'subscription_tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('free'),
  );
  static const VerificationMeta _trialEndsAtMeta = const VerificationMeta(
    'trialEndsAt',
  );
  @override
  late final GeneratedColumn<DateTime> trialEndsAt = GeneratedColumn<DateTime>(
    'trial_ends_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _antExpenseThresholdMeta =
      const VerificationMeta('antExpenseThreshold');
  @override
  late final GeneratedColumn<double> antExpenseThreshold =
      GeneratedColumn<double>(
        'ant_expense_threshold',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(10.0),
      );
  static const VerificationMeta _monthlyBudgetMeta = const VerificationMeta(
    'monthlyBudget',
  );
  @override
  late final GeneratedColumn<double> monthlyBudget = GeneratedColumn<double>(
    'monthly_budget',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1000.0),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    currency,
    language,
    subscriptionTier,
    trialEndsAt,
    antExpenseThreshold,
    monthlyBudget,
    displayName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('subscription_tier')) {
      context.handle(
        _subscriptionTierMeta,
        subscriptionTier.isAcceptableOrUnknown(
          data['subscription_tier']!,
          _subscriptionTierMeta,
        ),
      );
    }
    if (data.containsKey('trial_ends_at')) {
      context.handle(
        _trialEndsAtMeta,
        trialEndsAt.isAcceptableOrUnknown(
          data['trial_ends_at']!,
          _trialEndsAtMeta,
        ),
      );
    }
    if (data.containsKey('ant_expense_threshold')) {
      context.handle(
        _antExpenseThresholdMeta,
        antExpenseThreshold.isAcceptableOrUnknown(
          data['ant_expense_threshold']!,
          _antExpenseThresholdMeta,
        ),
      );
    }
    if (data.containsKey('monthly_budget')) {
      context.handle(
        _monthlyBudgetMeta,
        monthlyBudget.isAcceptableOrUnknown(
          data['monthly_budget']!,
          _monthlyBudgetMeta,
        ),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  LocalSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSetting(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      subscriptionTier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_tier'],
      )!,
      trialEndsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}trial_ends_at'],
      ),
      antExpenseThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ant_expense_threshold'],
      )!,
      monthlyBudget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_budget'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
    );
  }

  @override
  $LocalSettingsTable createAlias(String alias) {
    return $LocalSettingsTable(attachedDatabase, alias);
  }
}

class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final String userId;
  final String currency;
  final String language;
  final String subscriptionTier;
  final DateTime? trialEndsAt;
  final double antExpenseThreshold;
  final double monthlyBudget;
  final String? displayName;
  const LocalSetting({
    required this.userId,
    required this.currency,
    required this.language,
    required this.subscriptionTier,
    this.trialEndsAt,
    required this.antExpenseThreshold,
    required this.monthlyBudget,
    this.displayName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['currency'] = Variable<String>(currency);
    map['language'] = Variable<String>(language);
    map['subscription_tier'] = Variable<String>(subscriptionTier);
    if (!nullToAbsent || trialEndsAt != null) {
      map['trial_ends_at'] = Variable<DateTime>(trialEndsAt);
    }
    map['ant_expense_threshold'] = Variable<double>(antExpenseThreshold);
    map['monthly_budget'] = Variable<double>(monthlyBudget);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    return map;
  }

  LocalSettingsCompanion toCompanion(bool nullToAbsent) {
    return LocalSettingsCompanion(
      userId: Value(userId),
      currency: Value(currency),
      language: Value(language),
      subscriptionTier: Value(subscriptionTier),
      trialEndsAt: trialEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(trialEndsAt),
      antExpenseThreshold: Value(antExpenseThreshold),
      monthlyBudget: Value(monthlyBudget),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
    );
  }

  factory LocalSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSetting(
      userId: serializer.fromJson<String>(json['userId']),
      currency: serializer.fromJson<String>(json['currency']),
      language: serializer.fromJson<String>(json['language']),
      subscriptionTier: serializer.fromJson<String>(json['subscriptionTier']),
      trialEndsAt: serializer.fromJson<DateTime?>(json['trialEndsAt']),
      antExpenseThreshold: serializer.fromJson<double>(
        json['antExpenseThreshold'],
      ),
      monthlyBudget: serializer.fromJson<double>(json['monthlyBudget']),
      displayName: serializer.fromJson<String?>(json['displayName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'currency': serializer.toJson<String>(currency),
      'language': serializer.toJson<String>(language),
      'subscriptionTier': serializer.toJson<String>(subscriptionTier),
      'trialEndsAt': serializer.toJson<DateTime?>(trialEndsAt),
      'antExpenseThreshold': serializer.toJson<double>(antExpenseThreshold),
      'monthlyBudget': serializer.toJson<double>(monthlyBudget),
      'displayName': serializer.toJson<String?>(displayName),
    };
  }

  LocalSetting copyWith({
    String? userId,
    String? currency,
    String? language,
    String? subscriptionTier,
    Value<DateTime?> trialEndsAt = const Value.absent(),
    double? antExpenseThreshold,
    double? monthlyBudget,
    Value<String?> displayName = const Value.absent(),
  }) => LocalSetting(
    userId: userId ?? this.userId,
    currency: currency ?? this.currency,
    language: language ?? this.language,
    subscriptionTier: subscriptionTier ?? this.subscriptionTier,
    trialEndsAt: trialEndsAt.present ? trialEndsAt.value : this.trialEndsAt,
    antExpenseThreshold: antExpenseThreshold ?? this.antExpenseThreshold,
    monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    displayName: displayName.present ? displayName.value : this.displayName,
  );
  LocalSetting copyWithCompanion(LocalSettingsCompanion data) {
    return LocalSetting(
      userId: data.userId.present ? data.userId.value : this.userId,
      currency: data.currency.present ? data.currency.value : this.currency,
      language: data.language.present ? data.language.value : this.language,
      subscriptionTier: data.subscriptionTier.present
          ? data.subscriptionTier.value
          : this.subscriptionTier,
      trialEndsAt: data.trialEndsAt.present
          ? data.trialEndsAt.value
          : this.trialEndsAt,
      antExpenseThreshold: data.antExpenseThreshold.present
          ? data.antExpenseThreshold.value
          : this.antExpenseThreshold,
      monthlyBudget: data.monthlyBudget.present
          ? data.monthlyBudget.value
          : this.monthlyBudget,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSetting(')
          ..write('userId: $userId, ')
          ..write('currency: $currency, ')
          ..write('language: $language, ')
          ..write('subscriptionTier: $subscriptionTier, ')
          ..write('trialEndsAt: $trialEndsAt, ')
          ..write('antExpenseThreshold: $antExpenseThreshold, ')
          ..write('monthlyBudget: $monthlyBudget, ')
          ..write('displayName: $displayName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    currency,
    language,
    subscriptionTier,
    trialEndsAt,
    antExpenseThreshold,
    monthlyBudget,
    displayName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSetting &&
          other.userId == this.userId &&
          other.currency == this.currency &&
          other.language == this.language &&
          other.subscriptionTier == this.subscriptionTier &&
          other.trialEndsAt == this.trialEndsAt &&
          other.antExpenseThreshold == this.antExpenseThreshold &&
          other.monthlyBudget == this.monthlyBudget &&
          other.displayName == this.displayName);
}

class LocalSettingsCompanion extends UpdateCompanion<LocalSetting> {
  final Value<String> userId;
  final Value<String> currency;
  final Value<String> language;
  final Value<String> subscriptionTier;
  final Value<DateTime?> trialEndsAt;
  final Value<double> antExpenseThreshold;
  final Value<double> monthlyBudget;
  final Value<String?> displayName;
  final Value<int> rowid;
  const LocalSettingsCompanion({
    this.userId = const Value.absent(),
    this.currency = const Value.absent(),
    this.language = const Value.absent(),
    this.subscriptionTier = const Value.absent(),
    this.trialEndsAt = const Value.absent(),
    this.antExpenseThreshold = const Value.absent(),
    this.monthlyBudget = const Value.absent(),
    this.displayName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    required String userId,
    this.currency = const Value.absent(),
    this.language = const Value.absent(),
    this.subscriptionTier = const Value.absent(),
    this.trialEndsAt = const Value.absent(),
    this.antExpenseThreshold = const Value.absent(),
    this.monthlyBudget = const Value.absent(),
    this.displayName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<LocalSetting> custom({
    Expression<String>? userId,
    Expression<String>? currency,
    Expression<String>? language,
    Expression<String>? subscriptionTier,
    Expression<DateTime>? trialEndsAt,
    Expression<double>? antExpenseThreshold,
    Expression<double>? monthlyBudget,
    Expression<String>? displayName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (currency != null) 'currency': currency,
      if (language != null) 'language': language,
      if (subscriptionTier != null) 'subscription_tier': subscriptionTier,
      if (trialEndsAt != null) 'trial_ends_at': trialEndsAt,
      if (antExpenseThreshold != null)
        'ant_expense_threshold': antExpenseThreshold,
      if (monthlyBudget != null) 'monthly_budget': monthlyBudget,
      if (displayName != null) 'display_name': displayName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSettingsCompanion copyWith({
    Value<String>? userId,
    Value<String>? currency,
    Value<String>? language,
    Value<String>? subscriptionTier,
    Value<DateTime?>? trialEndsAt,
    Value<double>? antExpenseThreshold,
    Value<double>? monthlyBudget,
    Value<String?>? displayName,
    Value<int>? rowid,
  }) {
    return LocalSettingsCompanion(
      userId: userId ?? this.userId,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      antExpenseThreshold: antExpenseThreshold ?? this.antExpenseThreshold,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      displayName: displayName ?? this.displayName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (subscriptionTier.present) {
      map['subscription_tier'] = Variable<String>(subscriptionTier.value);
    }
    if (trialEndsAt.present) {
      map['trial_ends_at'] = Variable<DateTime>(trialEndsAt.value);
    }
    if (antExpenseThreshold.present) {
      map['ant_expense_threshold'] = Variable<double>(
        antExpenseThreshold.value,
      );
    }
    if (monthlyBudget.present) {
      map['monthly_budget'] = Variable<double>(monthlyBudget.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettingsCompanion(')
          ..write('userId: $userId, ')
          ..write('currency: $currency, ')
          ..write('language: $language, ')
          ..write('subscriptionTier: $subscriptionTier, ')
          ..write('trialEndsAt: $trialEndsAt, ')
          ..write('antExpenseThreshold: $antExpenseThreshold, ')
          ..write('monthlyBudget: $monthlyBudget, ')
          ..write('displayName: $displayName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetTable,
    action,
    recordId,
    payload,
    synced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String targetTable;
  final String action;
  final String recordId;
  final String payload;
  final bool synced;
  final DateTime createdAt;
  const SyncQueueData({
    required this.id,
    required this.targetTable,
    required this.action,
    required this.recordId,
    required this.payload,
    required this.synced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_table'] = Variable<String>(targetTable);
    map['action'] = Variable<String>(action);
    map['record_id'] = Variable<String>(recordId);
    map['payload'] = Variable<String>(payload);
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      action: Value(action),
      recordId: Value(recordId),
      payload: Value(payload),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      action: serializer.fromJson<String>(json['action']),
      recordId: serializer.fromJson<String>(json['recordId']),
      payload: serializer.fromJson<String>(json['payload']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'action': serializer.toJson<String>(action),
      'recordId': serializer.toJson<String>(recordId),
      'payload': serializer.toJson<String>(payload),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? targetTable,
    String? action,
    String? recordId,
    String? payload,
    bool? synced,
    DateTime? createdAt,
  }) => SyncQueueData(
    id: id ?? this.id,
    targetTable: targetTable ?? this.targetTable,
    action: action ?? this.action,
    recordId: recordId ?? this.recordId,
    payload: payload ?? this.payload,
    synced: synced ?? this.synced,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      action: data.action.present ? data.action.value : this.action,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      payload: data.payload.present ? data.payload.value : this.payload,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('action: $action, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetTable,
    action,
    recordId,
    payload,
    synced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.action == this.action &&
          other.recordId == this.recordId &&
          other.payload == this.payload &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> targetTable;
  final Value<String> action;
  final Value<String> recordId;
  final Value<String> payload;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.action = const Value.absent(),
    this.recordId = const Value.absent(),
    this.payload = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String targetTable,
    required String action,
    required String recordId,
    required String payload,
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : targetTable = Value(targetTable),
       action = Value(action),
       recordId = Value(recordId),
       payload = Value(payload);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? targetTable,
    Expression<String>? action,
    Expression<String>? recordId,
    Expression<String>? payload,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'target_table': targetTable,
      if (action != null) 'action': action,
      if (recordId != null) 'record_id': recordId,
      if (payload != null) 'payload': payload,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? targetTable,
    Value<String>? action,
    Value<String>? recordId,
    Value<String>? payload,
    Value<bool>? synced,
    Value<DateTime>? createdAt,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      action: action ?? this.action,
      recordId: recordId ?? this.recordId,
      payload: payload ?? this.payload,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('action: $action, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LocalUserCategoryMemoryTable extends LocalUserCategoryMemory
    with TableInfo<$LocalUserCategoryMemoryTable, LocalUserCategoryMemoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUserCategoryMemoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keywordMeta = const VerificationMeta(
    'keyword',
  );
  @override
  late final GeneratedColumn<String> keyword = GeneratedColumn<String>(
    'keyword',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subcategoryMeta = const VerificationMeta(
    'subcategory',
  );
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
    'subcategory',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timesUsedMeta = const VerificationMeta(
    'timesUsed',
  );
  @override
  late final GeneratedColumn<int> timesUsed = GeneratedColumn<int>(
    'times_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    keyword,
    category,
    subcategory,
    timesUsed,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_user_category_memory';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalUserCategoryMemoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('keyword')) {
      context.handle(
        _keywordMeta,
        keyword.isAcceptableOrUnknown(data['keyword']!, _keywordMeta),
      );
    } else if (isInserting) {
      context.missing(_keywordMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('subcategory')) {
      context.handle(
        _subcategoryMeta,
        subcategory.isAcceptableOrUnknown(
          data['subcategory']!,
          _subcategoryMeta,
        ),
      );
    }
    if (data.containsKey('times_used')) {
      context.handle(
        _timesUsedMeta,
        timesUsed.isAcceptableOrUnknown(data['times_used']!, _timesUsedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUserCategoryMemoryData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUserCategoryMemoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      keyword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keyword'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      subcategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subcategory'],
      ),
      timesUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_used'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalUserCategoryMemoryTable createAlias(String alias) {
    return $LocalUserCategoryMemoryTable(attachedDatabase, alias);
  }
}

class LocalUserCategoryMemoryData extends DataClass
    implements Insertable<LocalUserCategoryMemoryData> {
  final String id;
  final String userId;
  final String keyword;
  final String category;
  final String? subcategory;
  final int timesUsed;
  final DateTime updatedAt;
  const LocalUserCategoryMemoryData({
    required this.id,
    required this.userId,
    required this.keyword,
    required this.category,
    this.subcategory,
    required this.timesUsed,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['keyword'] = Variable<String>(keyword);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || subcategory != null) {
      map['subcategory'] = Variable<String>(subcategory);
    }
    map['times_used'] = Variable<int>(timesUsed);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalUserCategoryMemoryCompanion toCompanion(bool nullToAbsent) {
    return LocalUserCategoryMemoryCompanion(
      id: Value(id),
      userId: Value(userId),
      keyword: Value(keyword),
      category: Value(category),
      subcategory: subcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategory),
      timesUsed: Value(timesUsed),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalUserCategoryMemoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUserCategoryMemoryData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      keyword: serializer.fromJson<String>(json['keyword']),
      category: serializer.fromJson<String>(json['category']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      timesUsed: serializer.fromJson<int>(json['timesUsed']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'keyword': serializer.toJson<String>(keyword),
      'category': serializer.toJson<String>(category),
      'subcategory': serializer.toJson<String?>(subcategory),
      'timesUsed': serializer.toJson<int>(timesUsed),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalUserCategoryMemoryData copyWith({
    String? id,
    String? userId,
    String? keyword,
    String? category,
    Value<String?> subcategory = const Value.absent(),
    int? timesUsed,
    DateTime? updatedAt,
  }) => LocalUserCategoryMemoryData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    keyword: keyword ?? this.keyword,
    category: category ?? this.category,
    subcategory: subcategory.present ? subcategory.value : this.subcategory,
    timesUsed: timesUsed ?? this.timesUsed,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalUserCategoryMemoryData copyWithCompanion(
    LocalUserCategoryMemoryCompanion data,
  ) {
    return LocalUserCategoryMemoryData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      keyword: data.keyword.present ? data.keyword.value : this.keyword,
      category: data.category.present ? data.category.value : this.category,
      subcategory: data.subcategory.present
          ? data.subcategory.value
          : this.subcategory,
      timesUsed: data.timesUsed.present ? data.timesUsed.value : this.timesUsed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserCategoryMemoryData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('keyword: $keyword, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('timesUsed: $timesUsed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    keyword,
    category,
    subcategory,
    timesUsed,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUserCategoryMemoryData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.keyword == this.keyword &&
          other.category == this.category &&
          other.subcategory == this.subcategory &&
          other.timesUsed == this.timesUsed &&
          other.updatedAt == this.updatedAt);
}

class LocalUserCategoryMemoryCompanion
    extends UpdateCompanion<LocalUserCategoryMemoryData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> keyword;
  final Value<String> category;
  final Value<String?> subcategory;
  final Value<int> timesUsed;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalUserCategoryMemoryCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.keyword = const Value.absent(),
    this.category = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.timesUsed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUserCategoryMemoryCompanion.insert({
    required String id,
    required String userId,
    required String keyword,
    required String category,
    this.subcategory = const Value.absent(),
    this.timesUsed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       keyword = Value(keyword),
       category = Value(category);
  static Insertable<LocalUserCategoryMemoryData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? keyword,
    Expression<String>? category,
    Expression<String>? subcategory,
    Expression<int>? timesUsed,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (keyword != null) 'keyword': keyword,
      if (category != null) 'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      if (timesUsed != null) 'times_used': timesUsed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUserCategoryMemoryCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? keyword,
    Value<String>? category,
    Value<String?>? subcategory,
    Value<int>? timesUsed,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalUserCategoryMemoryCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      keyword: keyword ?? this.keyword,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      timesUsed: timesUsed ?? this.timesUsed,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (keyword.present) {
      map['keyword'] = Variable<String>(keyword.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subcategory.present) {
      map['subcategory'] = Variable<String>(subcategory.value);
    }
    if (timesUsed.present) {
      map['times_used'] = Variable<int>(timesUsed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUserCategoryMemoryCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('keyword: $keyword, ')
          ..write('category: $category, ')
          ..write('subcategory: $subcategory, ')
          ..write('timesUsed: $timesUsed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalExchangeRatesTable extends LocalExchangeRates
    with TableInfo<$LocalExchangeRatesTable, LocalExchangeRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _baseCurrencyMeta = const VerificationMeta(
    'baseCurrency',
  );
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
    'base_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetCurrencyMeta = const VerificationMeta(
    'targetCurrency',
  );
  @override
  late final GeneratedColumn<String> targetCurrency = GeneratedColumn<String>(
    'target_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    baseCurrency,
    targetCurrency,
    rate,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_exchange_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalExchangeRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('base_currency')) {
      context.handle(
        _baseCurrencyMeta,
        baseCurrency.isAcceptableOrUnknown(
          data['base_currency']!,
          _baseCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseCurrencyMeta);
    }
    if (data.containsKey('target_currency')) {
      context.handle(
        _targetCurrencyMeta,
        targetCurrency.isAcceptableOrUnknown(
          data['target_currency']!,
          _targetCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetCurrencyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {baseCurrency, targetCurrency};
  @override
  LocalExchangeRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalExchangeRate(
      baseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_currency'],
      )!,
      targetCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_currency'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $LocalExchangeRatesTable createAlias(String alias) {
    return $LocalExchangeRatesTable(attachedDatabase, alias);
  }
}

class LocalExchangeRate extends DataClass
    implements Insertable<LocalExchangeRate> {
  final String baseCurrency;
  final String targetCurrency;
  final double rate;
  final DateTime lastUpdated;
  const LocalExchangeRate({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['base_currency'] = Variable<String>(baseCurrency);
    map['target_currency'] = Variable<String>(targetCurrency);
    map['rate'] = Variable<double>(rate);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  LocalExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return LocalExchangeRatesCompanion(
      baseCurrency: Value(baseCurrency),
      targetCurrency: Value(targetCurrency),
      rate: Value(rate),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory LocalExchangeRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalExchangeRate(
      baseCurrency: serializer.fromJson<String>(json['baseCurrency']),
      targetCurrency: serializer.fromJson<String>(json['targetCurrency']),
      rate: serializer.fromJson<double>(json['rate']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'baseCurrency': serializer.toJson<String>(baseCurrency),
      'targetCurrency': serializer.toJson<String>(targetCurrency),
      'rate': serializer.toJson<double>(rate),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  LocalExchangeRate copyWith({
    String? baseCurrency,
    String? targetCurrency,
    double? rate,
    DateTime? lastUpdated,
  }) => LocalExchangeRate(
    baseCurrency: baseCurrency ?? this.baseCurrency,
    targetCurrency: targetCurrency ?? this.targetCurrency,
    rate: rate ?? this.rate,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  LocalExchangeRate copyWithCompanion(LocalExchangeRatesCompanion data) {
    return LocalExchangeRate(
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      targetCurrency: data.targetCurrency.present
          ? data.targetCurrency.value
          : this.targetCurrency,
      rate: data.rate.present ? data.rate.value : this.rate,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalExchangeRate(')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('targetCurrency: $targetCurrency, ')
          ..write('rate: $rate, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(baseCurrency, targetCurrency, rate, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalExchangeRate &&
          other.baseCurrency == this.baseCurrency &&
          other.targetCurrency == this.targetCurrency &&
          other.rate == this.rate &&
          other.lastUpdated == this.lastUpdated);
}

class LocalExchangeRatesCompanion extends UpdateCompanion<LocalExchangeRate> {
  final Value<String> baseCurrency;
  final Value<String> targetCurrency;
  final Value<double> rate;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const LocalExchangeRatesCompanion({
    this.baseCurrency = const Value.absent(),
    this.targetCurrency = const Value.absent(),
    this.rate = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalExchangeRatesCompanion.insert({
    required String baseCurrency,
    required String targetCurrency,
    required double rate,
    required DateTime lastUpdated,
    this.rowid = const Value.absent(),
  }) : baseCurrency = Value(baseCurrency),
       targetCurrency = Value(targetCurrency),
       rate = Value(rate),
       lastUpdated = Value(lastUpdated);
  static Insertable<LocalExchangeRate> custom({
    Expression<String>? baseCurrency,
    Expression<String>? targetCurrency,
    Expression<double>? rate,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (targetCurrency != null) 'target_currency': targetCurrency,
      if (rate != null) 'rate': rate,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalExchangeRatesCompanion copyWith({
    Value<String>? baseCurrency,
    Value<String>? targetCurrency,
    Value<double>? rate,
    Value<DateTime>? lastUpdated,
    Value<int>? rowid,
  }) {
    return LocalExchangeRatesCompanion(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      rate: rate ?? this.rate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (targetCurrency.present) {
      map['target_currency'] = Variable<String>(targetCurrency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalExchangeRatesCompanion(')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('targetCurrency: $targetCurrency, ')
          ..write('rate: $rate, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalTransactionsTable localTransactions =
      $LocalTransactionsTable(this);
  late final $LocalRecurringTable localRecurring = $LocalRecurringTable(this);
  late final $LocalGoalsTable localGoals = $LocalGoalsTable(this);
  late final $LocalSettingsTable localSettings = $LocalSettingsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $LocalUserCategoryMemoryTable localUserCategoryMemory =
      $LocalUserCategoryMemoryTable(this);
  late final $LocalExchangeRatesTable localExchangeRates =
      $LocalExchangeRatesTable(this);
  late final TransactionDao transactionDao = TransactionDao(
    this as AppDatabase,
  );
  late final RecurringDao recurringDao = RecurringDao(this as AppDatabase);
  late final GoalDao goalDao = GoalDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  late final UserCategoryMemoryDao userCategoryMemoryDao =
      UserCategoryMemoryDao(this as AppDatabase);
  late final ExchangeRateDao exchangeRateDao = ExchangeRateDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localTransactions,
    localRecurring,
    localGoals,
    localSettings,
    syncQueue,
    localUserCategoryMemory,
    localExchangeRates,
  ];
}

typedef $$LocalTransactionsTableCreateCompanionBuilder =
    LocalTransactionsCompanion Function({
      required String id,
      required String userId,
      Value<String> description,
      required double amount,
      Value<String> type,
      Value<String> category,
      Value<String> currency,
      required DateTime date,
      Value<bool> isAntExpense,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$LocalTransactionsTableUpdateCompanionBuilder =
    LocalTransactionsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> description,
      Value<double> amount,
      Value<String> type,
      Value<String> category,
      Value<String> currency,
      Value<DateTime> date,
      Value<bool> isAntExpense,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$LocalTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAntExpense => $composableBuilder(
    column: $table.isAntExpense,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAntExpense => $composableBuilder(
    column: $table.isAntExpense,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalTransactionsTable> {
  $$LocalTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isAntExpense => $composableBuilder(
    column: $table.isAntExpense,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalTransactionsTable,
          LocalTransaction,
          $$LocalTransactionsTableFilterComposer,
          $$LocalTransactionsTableOrderingComposer,
          $$LocalTransactionsTableAnnotationComposer,
          $$LocalTransactionsTableCreateCompanionBuilder,
          $$LocalTransactionsTableUpdateCompanionBuilder,
          (
            LocalTransaction,
            BaseReferences<
              _$AppDatabase,
              $LocalTransactionsTable,
              LocalTransaction
            >,
          ),
          LocalTransaction,
          PrefetchHooks Function()
        > {
  $$LocalTransactionsTableTableManager(
    _$AppDatabase db,
    $LocalTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isAntExpense = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTransactionsCompanion(
                id: id,
                userId: userId,
                description: description,
                amount: amount,
                type: type,
                category: category,
                currency: currency,
                date: date,
                isAntExpense: isAntExpense,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String> description = const Value.absent(),
                required double amount,
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> currency = const Value.absent(),
                required DateTime date,
                Value<bool> isAntExpense = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalTransactionsCompanion.insert(
                id: id,
                userId: userId,
                description: description,
                amount: amount,
                type: type,
                category: category,
                currency: currency,
                date: date,
                isAntExpense: isAntExpense,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalTransactionsTable,
      LocalTransaction,
      $$LocalTransactionsTableFilterComposer,
      $$LocalTransactionsTableOrderingComposer,
      $$LocalTransactionsTableAnnotationComposer,
      $$LocalTransactionsTableCreateCompanionBuilder,
      $$LocalTransactionsTableUpdateCompanionBuilder,
      (
        LocalTransaction,
        BaseReferences<
          _$AppDatabase,
          $LocalTransactionsTable,
          LocalTransaction
        >,
      ),
      LocalTransaction,
      PrefetchHooks Function()
    >;
typedef $$LocalRecurringTableCreateCompanionBuilder =
    LocalRecurringCompanion Function({
      required String id,
      required String userId,
      Value<String> description,
      required double amount,
      Value<String> type,
      Value<String> category,
      Value<String> frequency,
      Value<DateTime?> startDate,
      Value<DateTime?> nextDate,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$LocalRecurringTableUpdateCompanionBuilder =
    LocalRecurringCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> description,
      Value<double> amount,
      Value<String> type,
      Value<String> category,
      Value<String> frequency,
      Value<DateTime?> startDate,
      Value<DateTime?> nextDate,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$LocalRecurringTableFilterComposer
    extends Composer<_$AppDatabase, $LocalRecurringTable> {
  $$LocalRecurringTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDate => $composableBuilder(
    column: $table.nextDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalRecurringTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalRecurringTable> {
  $$LocalRecurringTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDate => $composableBuilder(
    column: $table.nextDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalRecurringTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalRecurringTable> {
  $$LocalRecurringTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDate =>
      $composableBuilder(column: $table.nextDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalRecurringTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalRecurringTable,
          LocalRecurringData,
          $$LocalRecurringTableFilterComposer,
          $$LocalRecurringTableOrderingComposer,
          $$LocalRecurringTableAnnotationComposer,
          $$LocalRecurringTableCreateCompanionBuilder,
          $$LocalRecurringTableUpdateCompanionBuilder,
          (
            LocalRecurringData,
            BaseReferences<
              _$AppDatabase,
              $LocalRecurringTable,
              LocalRecurringData
            >,
          ),
          LocalRecurringData,
          PrefetchHooks Function()
        > {
  $$LocalRecurringTableTableManager(
    _$AppDatabase db,
    $LocalRecurringTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalRecurringTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalRecurringTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalRecurringTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> nextDate = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalRecurringCompanion(
                id: id,
                userId: userId,
                description: description,
                amount: amount,
                type: type,
                category: category,
                frequency: frequency,
                startDate: startDate,
                nextDate: nextDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                Value<String> description = const Value.absent(),
                required double amount,
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> nextDate = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalRecurringCompanion.insert(
                id: id,
                userId: userId,
                description: description,
                amount: amount,
                type: type,
                category: category,
                frequency: frequency,
                startDate: startDate,
                nextDate: nextDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalRecurringTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalRecurringTable,
      LocalRecurringData,
      $$LocalRecurringTableFilterComposer,
      $$LocalRecurringTableOrderingComposer,
      $$LocalRecurringTableAnnotationComposer,
      $$LocalRecurringTableCreateCompanionBuilder,
      $$LocalRecurringTableUpdateCompanionBuilder,
      (
        LocalRecurringData,
        BaseReferences<_$AppDatabase, $LocalRecurringTable, LocalRecurringData>,
      ),
      LocalRecurringData,
      PrefetchHooks Function()
    >;
typedef $$LocalGoalsTableCreateCompanionBuilder =
    LocalGoalsCompanion Function({
      required String id,
      required String userId,
      required String name,
      required double targetAmount,
      Value<double> currentAmount,
      Value<double> initialAmount,
      Value<DateTime?> deadline,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$LocalGoalsTableUpdateCompanionBuilder =
    LocalGoalsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<double> targetAmount,
      Value<double> currentAmount,
      Value<double> initialAmount,
      Value<DateTime?> deadline,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$LocalGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalGoalsTable> {
  $$LocalGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalGoalsTable> {
  $$LocalGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalGoalsTable> {
  $$LocalGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get initialAmount => $composableBuilder(
    column: $table.initialAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalGoalsTable,
          LocalGoal,
          $$LocalGoalsTableFilterComposer,
          $$LocalGoalsTableOrderingComposer,
          $$LocalGoalsTableAnnotationComposer,
          $$LocalGoalsTableCreateCompanionBuilder,
          $$LocalGoalsTableUpdateCompanionBuilder,
          (
            LocalGoal,
            BaseReferences<_$AppDatabase, $LocalGoalsTable, LocalGoal>,
          ),
          LocalGoal,
          PrefetchHooks Function()
        > {
  $$LocalGoalsTableTableManager(_$AppDatabase db, $LocalGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> targetAmount = const Value.absent(),
                Value<double> currentAmount = const Value.absent(),
                Value<double> initialAmount = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalGoalsCompanion(
                id: id,
                userId: userId,
                name: name,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                initialAmount: initialAmount,
                deadline: deadline,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required double targetAmount,
                Value<double> currentAmount = const Value.absent(),
                Value<double> initialAmount = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalGoalsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                initialAmount: initialAmount,
                deadline: deadline,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalGoalsTable,
      LocalGoal,
      $$LocalGoalsTableFilterComposer,
      $$LocalGoalsTableOrderingComposer,
      $$LocalGoalsTableAnnotationComposer,
      $$LocalGoalsTableCreateCompanionBuilder,
      $$LocalGoalsTableUpdateCompanionBuilder,
      (LocalGoal, BaseReferences<_$AppDatabase, $LocalGoalsTable, LocalGoal>),
      LocalGoal,
      PrefetchHooks Function()
    >;
typedef $$LocalSettingsTableCreateCompanionBuilder =
    LocalSettingsCompanion Function({
      required String userId,
      Value<String> currency,
      Value<String> language,
      Value<String> subscriptionTier,
      Value<DateTime?> trialEndsAt,
      Value<double> antExpenseThreshold,
      Value<double> monthlyBudget,
      Value<String?> displayName,
      Value<int> rowid,
    });
typedef $$LocalSettingsTableUpdateCompanionBuilder =
    LocalSettingsCompanion Function({
      Value<String> userId,
      Value<String> currency,
      Value<String> language,
      Value<String> subscriptionTier,
      Value<DateTime?> trialEndsAt,
      Value<double> antExpenseThreshold,
      Value<double> monthlyBudget,
      Value<String?> displayName,
      Value<int> rowid,
    });

class $$LocalSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionTier => $composableBuilder(
    column: $table.subscriptionTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get trialEndsAt => $composableBuilder(
    column: $table.trialEndsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get antExpenseThreshold => $composableBuilder(
    column: $table.antExpenseThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyBudget => $composableBuilder(
    column: $table.monthlyBudget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionTier => $composableBuilder(
    column: $table.subscriptionTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get trialEndsAt => $composableBuilder(
    column: $table.trialEndsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get antExpenseThreshold => $composableBuilder(
    column: $table.antExpenseThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyBudget => $composableBuilder(
    column: $table.monthlyBudget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get subscriptionTier => $composableBuilder(
    column: $table.subscriptionTier,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get trialEndsAt => $composableBuilder(
    column: $table.trialEndsAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get antExpenseThreshold => $composableBuilder(
    column: $table.antExpenseThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<double> get monthlyBudget => $composableBuilder(
    column: $table.monthlyBudget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );
}

class $$LocalSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSettingsTable,
          LocalSetting,
          $$LocalSettingsTableFilterComposer,
          $$LocalSettingsTableOrderingComposer,
          $$LocalSettingsTableAnnotationComposer,
          $$LocalSettingsTableCreateCompanionBuilder,
          $$LocalSettingsTableUpdateCompanionBuilder,
          (
            LocalSetting,
            BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
          ),
          LocalSetting,
          PrefetchHooks Function()
        > {
  $$LocalSettingsTableTableManager(_$AppDatabase db, $LocalSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> subscriptionTier = const Value.absent(),
                Value<DateTime?> trialEndsAt = const Value.absent(),
                Value<double> antExpenseThreshold = const Value.absent(),
                Value<double> monthlyBudget = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSettingsCompanion(
                userId: userId,
                currency: currency,
                language: language,
                subscriptionTier: subscriptionTier,
                trialEndsAt: trialEndsAt,
                antExpenseThreshold: antExpenseThreshold,
                monthlyBudget: monthlyBudget,
                displayName: displayName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<String> currency = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> subscriptionTier = const Value.absent(),
                Value<DateTime?> trialEndsAt = const Value.absent(),
                Value<double> antExpenseThreshold = const Value.absent(),
                Value<double> monthlyBudget = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSettingsCompanion.insert(
                userId: userId,
                currency: currency,
                language: language,
                subscriptionTier: subscriptionTier,
                trialEndsAt: trialEndsAt,
                antExpenseThreshold: antExpenseThreshold,
                monthlyBudget: monthlyBudget,
                displayName: displayName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSettingsTable,
      LocalSetting,
      $$LocalSettingsTableFilterComposer,
      $$LocalSettingsTableOrderingComposer,
      $$LocalSettingsTableAnnotationComposer,
      $$LocalSettingsTableCreateCompanionBuilder,
      $$LocalSettingsTableUpdateCompanionBuilder,
      (
        LocalSetting,
        BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
      ),
      LocalSetting,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String targetTable,
      required String action,
      required String recordId,
      required String payload,
      Value<bool> synced,
      Value<DateTime> createdAt,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> targetTable,
      Value<String> action,
      Value<String> recordId,
      Value<String> payload,
      Value<bool> synced,
      Value<DateTime> createdAt,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                targetTable: targetTable,
                action: action,
                recordId: recordId,
                payload: payload,
                synced: synced,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String targetTable,
                required String action,
                required String recordId,
                required String payload,
                Value<bool> synced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                targetTable: targetTable,
                action: action,
                recordId: recordId,
                payload: payload,
                synced: synced,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$LocalUserCategoryMemoryTableCreateCompanionBuilder =
    LocalUserCategoryMemoryCompanion Function({
      required String id,
      required String userId,
      required String keyword,
      required String category,
      Value<String?> subcategory,
      Value<int> timesUsed,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LocalUserCategoryMemoryTableUpdateCompanionBuilder =
    LocalUserCategoryMemoryCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> keyword,
      Value<String> category,
      Value<String?> subcategory,
      Value<int> timesUsed,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalUserCategoryMemoryTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUserCategoryMemoryTable> {
  $$LocalUserCategoryMemoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyword => $composableBuilder(
    column: $table.keyword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesUsed => $composableBuilder(
    column: $table.timesUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalUserCategoryMemoryTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUserCategoryMemoryTable> {
  $$LocalUserCategoryMemoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyword => $composableBuilder(
    column: $table.keyword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesUsed => $composableBuilder(
    column: $table.timesUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalUserCategoryMemoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUserCategoryMemoryTable> {
  $$LocalUserCategoryMemoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get keyword =>
      $composableBuilder(column: $table.keyword, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get subcategory => $composableBuilder(
    column: $table.subcategory,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesUsed =>
      $composableBuilder(column: $table.timesUsed, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalUserCategoryMemoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalUserCategoryMemoryTable,
          LocalUserCategoryMemoryData,
          $$LocalUserCategoryMemoryTableFilterComposer,
          $$LocalUserCategoryMemoryTableOrderingComposer,
          $$LocalUserCategoryMemoryTableAnnotationComposer,
          $$LocalUserCategoryMemoryTableCreateCompanionBuilder,
          $$LocalUserCategoryMemoryTableUpdateCompanionBuilder,
          (
            LocalUserCategoryMemoryData,
            BaseReferences<
              _$AppDatabase,
              $LocalUserCategoryMemoryTable,
              LocalUserCategoryMemoryData
            >,
          ),
          LocalUserCategoryMemoryData,
          PrefetchHooks Function()
        > {
  $$LocalUserCategoryMemoryTableTableManager(
    _$AppDatabase db,
    $LocalUserCategoryMemoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUserCategoryMemoryTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalUserCategoryMemoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalUserCategoryMemoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> keyword = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> subcategory = const Value.absent(),
                Value<int> timesUsed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserCategoryMemoryCompanion(
                id: id,
                userId: userId,
                keyword: keyword,
                category: category,
                subcategory: subcategory,
                timesUsed: timesUsed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String keyword,
                required String category,
                Value<String?> subcategory = const Value.absent(),
                Value<int> timesUsed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalUserCategoryMemoryCompanion.insert(
                id: id,
                userId: userId,
                keyword: keyword,
                category: category,
                subcategory: subcategory,
                timesUsed: timesUsed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalUserCategoryMemoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalUserCategoryMemoryTable,
      LocalUserCategoryMemoryData,
      $$LocalUserCategoryMemoryTableFilterComposer,
      $$LocalUserCategoryMemoryTableOrderingComposer,
      $$LocalUserCategoryMemoryTableAnnotationComposer,
      $$LocalUserCategoryMemoryTableCreateCompanionBuilder,
      $$LocalUserCategoryMemoryTableUpdateCompanionBuilder,
      (
        LocalUserCategoryMemoryData,
        BaseReferences<
          _$AppDatabase,
          $LocalUserCategoryMemoryTable,
          LocalUserCategoryMemoryData
        >,
      ),
      LocalUserCategoryMemoryData,
      PrefetchHooks Function()
    >;
typedef $$LocalExchangeRatesTableCreateCompanionBuilder =
    LocalExchangeRatesCompanion Function({
      required String baseCurrency,
      required String targetCurrency,
      required double rate,
      required DateTime lastUpdated,
      Value<int> rowid,
    });
typedef $$LocalExchangeRatesTableUpdateCompanionBuilder =
    LocalExchangeRatesCompanion Function({
      Value<String> baseCurrency,
      Value<String> targetCurrency,
      Value<double> rate,
      Value<DateTime> lastUpdated,
      Value<int> rowid,
    });

class $$LocalExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalExchangeRatesTable> {
  $$LocalExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetCurrency => $composableBuilder(
    column: $table.targetCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalExchangeRatesTable> {
  $$LocalExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetCurrency => $composableBuilder(
    column: $table.targetCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalExchangeRatesTable> {
  $$LocalExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetCurrency => $composableBuilder(
    column: $table.targetCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );
}

class $$LocalExchangeRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalExchangeRatesTable,
          LocalExchangeRate,
          $$LocalExchangeRatesTableFilterComposer,
          $$LocalExchangeRatesTableOrderingComposer,
          $$LocalExchangeRatesTableAnnotationComposer,
          $$LocalExchangeRatesTableCreateCompanionBuilder,
          $$LocalExchangeRatesTableUpdateCompanionBuilder,
          (
            LocalExchangeRate,
            BaseReferences<
              _$AppDatabase,
              $LocalExchangeRatesTable,
              LocalExchangeRate
            >,
          ),
          LocalExchangeRate,
          PrefetchHooks Function()
        > {
  $$LocalExchangeRatesTableTableManager(
    _$AppDatabase db,
    $LocalExchangeRatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalExchangeRatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> baseCurrency = const Value.absent(),
                Value<String> targetCurrency = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalExchangeRatesCompanion(
                baseCurrency: baseCurrency,
                targetCurrency: targetCurrency,
                rate: rate,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String baseCurrency,
                required String targetCurrency,
                required double rate,
                required DateTime lastUpdated,
                Value<int> rowid = const Value.absent(),
              }) => LocalExchangeRatesCompanion.insert(
                baseCurrency: baseCurrency,
                targetCurrency: targetCurrency,
                rate: rate,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalExchangeRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalExchangeRatesTable,
      LocalExchangeRate,
      $$LocalExchangeRatesTableFilterComposer,
      $$LocalExchangeRatesTableOrderingComposer,
      $$LocalExchangeRatesTableAnnotationComposer,
      $$LocalExchangeRatesTableCreateCompanionBuilder,
      $$LocalExchangeRatesTableUpdateCompanionBuilder,
      (
        LocalExchangeRate,
        BaseReferences<
          _$AppDatabase,
          $LocalExchangeRatesTable,
          LocalExchangeRate
        >,
      ),
      LocalExchangeRate,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalTransactionsTableTableManager get localTransactions =>
      $$LocalTransactionsTableTableManager(_db, _db.localTransactions);
  $$LocalRecurringTableTableManager get localRecurring =>
      $$LocalRecurringTableTableManager(_db, _db.localRecurring);
  $$LocalGoalsTableTableManager get localGoals =>
      $$LocalGoalsTableTableManager(_db, _db.localGoals);
  $$LocalSettingsTableTableManager get localSettings =>
      $$LocalSettingsTableTableManager(_db, _db.localSettings);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$LocalUserCategoryMemoryTableTableManager get localUserCategoryMemory =>
      $$LocalUserCategoryMemoryTableTableManager(
        _db,
        _db.localUserCategoryMemory,
      );
  $$LocalExchangeRatesTableTableManager get localExchangeRates =>
      $$LocalExchangeRatesTableTableManager(_db, _db.localExchangeRates);
}
