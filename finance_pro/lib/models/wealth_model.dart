class WealthModel {
  final String? id;
  final String userId;
  final double liquidCash;
  final double investments;
  final double realEstate;
  final double liabilities;
  final DateTime? lastRecalibratedDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WealthModel({
    this.id,
    required this.userId,
    this.liquidCash = 0,
    this.investments = 0,
    this.realEstate = 0,
    this.liabilities = 0,
    this.lastRecalibratedDate,
    this.createdAt,
    this.updatedAt,
  });

  double get totalAssets => liquidCash + investments + realEstate;
  double get netWorth => totalAssets - liabilities;

  /// Distribution percentages for pie chart
  Map<String, double> get assetDistribution {
    if (totalAssets == 0) return {};
    return {
      'Efectivo': liquidCash / totalAssets,
      'Inversiones': investments / totalAssets,
      'Inmuebles': realEstate / totalAssets,
    };
  }

  /// Debt-to-asset ratio (lower is better)
  double get debtRatio => totalAssets > 0 ? liabilities / totalAssets : 0;

  factory WealthModel.fromJson(Map<String, dynamic> json) {
    return WealthModel(
      id: json['id'],
      userId: json['user_id'],
      liquidCash: (json['liquid_cash'] as num?)?.toDouble() ?? 0,
      investments: (json['investments'] as num?)?.toDouble() ?? 0,
      realEstate: (json['real_estate'] as num?)?.toDouble() ?? 0,
      liabilities: (json['liabilities'] as num?)?.toDouble() ?? 0,
      lastRecalibratedDate: json['last_recalibrated_date'] != null
          ? DateTime.parse(json['last_recalibrated_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'liquid_cash': liquidCash,
      'investments': investments,
      'real_estate': realEstate,
      'liabilities': liabilities,
    };
  }

  WealthModel copyWith({
    double? liquidCash,
    double? investments,
    double? realEstate,
    double? liabilities,
  }) {
    return WealthModel(
      id: id,
      userId: userId,
      liquidCash: liquidCash ?? this.liquidCash,
      investments: investments ?? this.investments,
      realEstate: realEstate ?? this.realEstate,
      liabilities: liabilities ?? this.liabilities,
      lastRecalibratedDate: lastRecalibratedDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
