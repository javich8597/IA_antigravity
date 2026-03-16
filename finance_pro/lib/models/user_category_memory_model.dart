import 'package:drift/drift.dart';

class UserCategoryMemoryModel {
  final String id;
  final String userId;
  final String keyword;
  final String category;
  final String? subcategory;
  final int timesUsed;
  final DateTime updatedAt;

  UserCategoryMemoryModel({
    required this.id,
    required this.userId,
    required this.keyword,
    required this.category,
    this.subcategory,
    this.timesUsed = 1,
    required this.updatedAt,
  });

  factory UserCategoryMemoryModel.fromJson(Map<String, dynamic> json) {
    return UserCategoryMemoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      keyword: json['keyword'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      timesUsed: json['times_used'] as int? ?? 1,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'keyword': keyword,
      'category': category,
      if (subcategory != null) 'subcategory': subcategory,
      'times_used': timesUsed,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserCategoryMemoryModel copyWith({
    String? id,
    String? userId,
    String? keyword,
    String? category,
    String? subcategory,
    int? timesUsed,
    DateTime? updatedAt,
  }) {
    return UserCategoryMemoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      keyword: keyword ?? this.keyword,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      timesUsed: timesUsed ?? this.timesUsed,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
