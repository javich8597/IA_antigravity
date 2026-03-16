class UserSettingsModel {
  final String userId;
  final String currency;
  final String language;
  final String subscriptionTier; // 'free', 'trial', 'pro'
  final DateTime? trialEndsAt;
  final double antExpenseThreshold;
  final double monthlyBudget;
  final String? displayName;
  final DateTime? updatedAt;

  UserSettingsModel({
    required this.userId,
    this.currency = 'EUR',
    this.language = 'es',
    this.subscriptionTier = 'free',
    this.trialEndsAt,
    this.antExpenseThreshold = 10.0,
    this.monthlyBudget = 1000.0,
    this.displayName,
    this.updatedAt,
  });

  bool get isFree => subscriptionTier == 'free';

  bool get isTrial =>
      subscriptionTier == 'trial' &&
      trialEndsAt != null &&
      trialEndsAt!.isAfter(DateTime.now());

  bool get isPro => subscriptionTier == 'pro';

  bool get hasAccess => isPro || isTrial;

  String get currencySymbol {
    const symbols = {
      'EUR': '€', 'USD': '\$', 'GBP': '£', 'JPY': '¥',
      'CHF': 'CHF', 'CAD': 'CA\$', 'AUD': 'A\$', 'MXN': 'MX\$',
    };
    return symbols[currency] ?? currency;
  }

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      userId: json['user_id'],
      currency: json['currency'] ?? 'EUR',
      language: json['language'] ?? 'es',
      subscriptionTier: json['subscription_tier'] ?? 'free',
      trialEndsAt: json['trial_ends_at'] != null
          ? DateTime.parse(json['trial_ends_at'])
          : null,
      antExpenseThreshold:
          (json['ant_expense_threshold'] as num?)?.toDouble() ?? 10.0,
      monthlyBudget:
          (json['monthly_budget'] as num?)?.toDouble() ?? 1000.0,
      displayName: json['display_name'],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'currency': currency,
      'language': language,
      'subscription_tier': subscriptionTier,
      if (trialEndsAt != null)
        'trial_ends_at': trialEndsAt!.toIso8601String(),
      'ant_expense_threshold': antExpenseThreshold,
      'monthly_budget': monthlyBudget,
      if (displayName != null) 'display_name': displayName,
    };
  }

  UserSettingsModel copyWith({
    String? currency,
    String? language,
    String? subscriptionTier,
    DateTime? trialEndsAt,
    double? antExpenseThreshold,
    double? monthlyBudget,
    String? displayName,
  }) {
    return UserSettingsModel(
      userId: userId,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      antExpenseThreshold: antExpenseThreshold ?? this.antExpenseThreshold,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      displayName: displayName ?? this.displayName,
      updatedAt: updatedAt,
    );
  }
}
