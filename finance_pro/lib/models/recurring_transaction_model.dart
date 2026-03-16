class RecurringTransactionModel {
  final String? id;
  final String userId;
  final String description;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final String currency;
  final String frequency; // 'weekly', 'monthly', 'quarterly', 'biannually', 'annually'
  final DateTime? startDate;
  final DateTime? nextDate;
  final DateTime? createdAt;

  RecurringTransactionModel({
    this.id,
    required this.userId,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    this.currency = 'EUR',
    this.frequency = 'monthly',
    this.startDate,
    this.nextDate,
    this.createdAt,
  });

  factory RecurringTransactionModel.fromJson(Map<String, dynamic> json) {
    return RecurringTransactionModel(
      id: json['id'],
      userId: json['user_id'],
      description: json['description'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] ?? 'expense',
      category: json['category'] ?? 'General',
      currency: json['currency'] ?? 'EUR',
      frequency: json['frequency'] ?? 'monthly',
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      nextDate: json['next_date'] != null ? DateTime.parse(json['next_date']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'description': description,
      'amount': amount,
      'type': type,
      'category': category,
      'currency': currency,
      'frequency': frequency,
      if (startDate != null) 'start_date': startDate!.toIso8601String().split('T')[0],
      if (nextDate != null) 'next_date': nextDate!.toIso8601String().split('T')[0],
    };
  }

  RecurringTransactionModel copyWith({
    String? id,
    String? userId,
    String? description,
    double? amount,
    String? type,
    String? category,
    String? currency,
    String? frequency,
    DateTime? startDate,
    DateTime? nextDate,
  }) {
    return RecurringTransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextDate: nextDate ?? this.nextDate,
      createdAt: createdAt,
    );
  }
}
