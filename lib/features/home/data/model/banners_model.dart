import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/banners_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.imageUrl,
    required super.targetScreen,
    required super.active,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'targetScreen': targetScreen,
      'active': active,
    };
  }

  factory BannerModel.fromFirebaseJson(Map<String, dynamic> json) {
    return BannerModel(
      imageUrl: json['imageUrl'] ?? '',
      targetScreen: json['targetScreen'] ?? '',
      active: json['active'] ?? false,
    );
  }

  BannerEntity toEntity() {
    return BannerEntity(
      imageUrl: imageUrl,
      targetScreen: targetScreen,
      active: active,
    );
  }

}

