import '../../domain/entities/brand_category_entity.dart';

class BrandCategoryModel {
  final String brandId;
  final String categoryId;

  BrandCategoryModel({
    required this.brandId,
    required this.categoryId,
  });

  BrandCategoryEntity toEntity() {
    return BrandCategoryEntity(
      brandId: brandId,
      categoryId: categoryId,
    );
  }

  /// أسماء الحقول في Firestore محفوظة بحرف كبير في البداية
  /// (BrandId, CategoryId) — لازم تتطابق بالظبط (Case-Sensitive)،
  /// وإلا json['...'] هترجع null دايماً وتتحول لـ '' الفاضية.
  factory BrandCategoryModel.fromFirebaseJson(Map<String, dynamic> json) {
    return BrandCategoryModel(
      brandId: json['BrandId'] as String? ?? '',
      categoryId: json['CategoryId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BrandId': brandId,
      'CategoryId': categoryId,
    };
  }
}