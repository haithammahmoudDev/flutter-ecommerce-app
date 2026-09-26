import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/brand_entity.dart';

class BrandModel {
  final String id;
  final String name;
  final String image;
  final bool? isFeatured;
  final int? productsCount;

  BrandModel({
    required this.id,
    required this.image,
    required this.name,
    this.isFeatured,
    this.productsCount,
  });

  /// إنشاء كائن فارغ
  static BrandModel empty() => BrandModel(id: '', image: '', name: '');

  /// تحويل Map / Json إلى Model (مصدر خارجي عام، مش من Firestore مباشرة)
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isFeatured: json['isFeatured'] as bool?,
      productsCount: json['productsCount'] as int?,
    );
  }

  /// تحويل بيانات مستند Firestore إلى Model.
  /// [docId] لازم يكون معرف المستند الفعلي (doc.id)، مش أي حقل داخلي
  /// اسمه "id" جوه الـ data نفسها — الحقل ده غالباً فاضي في قاعدة البيانات.
  factory BrandModel.fromFirebaseJson(Map<String, dynamic> data, String docId) {
    return BrandModel(
      id: docId,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      isFeatured: data['isFeatured'] as bool?,
      productsCount: data['productCounts'] as int?,
    );
  }

  /// تحويل Model إلى Map / Json لتخزينه في Firebase
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Image': image,
      'IsFeatured': isFeatured,
      'ProductsCount': productsCount,
    };
  }

  factory BrandModel.fromEntity(BrandEntity entity) {
    return BrandModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      isFeatured: entity.isFeatured,
      productsCount: entity.productsCount,
    );
  }

  /// تحويل الـ Model الحالي إلى Entity مستقل تماماً لطبقة الـ Domain والـ UI
  BrandEntity toEntity() {
    return BrandEntity(
      id: id,
      name: name,
      image: image,
      isFeatured: isFeatured ?? false,
      productsCount: productsCount ?? 0,
    );
  }
}