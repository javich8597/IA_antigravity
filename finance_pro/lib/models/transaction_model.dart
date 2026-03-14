class TransactionModel {
  final String? id;
  final String userId;
  final String description;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final DateTime date;
  final DateTime? createdAt;

  TransactionModel({
    this.id,
    required this.userId,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      description: json['description'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] ?? 'expense',
      category: json['category'] ?? 'General',
      date: DateTime.parse(json['date']),
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
      'date': date.toIso8601String().split('T')[0],
    };
  }
}
