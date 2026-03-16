class GoalModel {
  final String? id;
  final String userId;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final double initialAmount;
  final DateTime? deadline;
  final DateTime? createdAt;

  GoalModel({
    this.id,
    required this.userId,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
    this.initialAmount = 0,
    this.deadline,
    this.createdAt,
  });

  double get progressPercent =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  double get remaining => (targetAmount - currentAmount).clamp(0.0, double.infinity);

  bool get isCompleted => currentAmount >= targetAmount;

  /// Estimated months to completion based on average monthly savings rate
  int? estimatedMonthsToComplete(double monthlySavingsRate) {
    if (monthlySavingsRate <= 0 || isCompleted) return null;
    return (remaining / monthlySavingsRate).ceil();
  }

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'] ?? '',
      targetAmount: (json['target_amount'] as num).toDouble(),
      currentAmount: (json['current_amount'] as num?)?.toDouble() ?? 0,
      initialAmount: (json['initial_amount'] as num?)?.toDouble() ?? 0,
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'name': name,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'initial_amount': initialAmount,
      if (deadline != null) 'deadline': deadline!.toIso8601String().split('T')[0],
    };
  }

  GoalModel copyWith({
    String? id,
    String? userId,
    String? name,
    double? targetAmount,
    double? currentAmount,
    double? initialAmount,
    DateTime? deadline,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      initialAmount: initialAmount ?? this.initialAmount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt,
    );
  }
}
