class ReviewEntity {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? storeResponse;
  final DateTime? storeResponseDate;

  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.updatedAt,
    this.storeResponse,
    this.storeResponseDate,
  });

  bool get isEdited => updatedAt != null;
}