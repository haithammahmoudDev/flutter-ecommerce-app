class CategoryEntity {
  final String id;
   final String name;
   final String image;
   final bool? isFeatured;

  const CategoryEntity({
     required this.name,
     required this.image,
     this.isFeatured,
    required this.id,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? image,
    String? parentId,
    bool? isFeatured,
  }) {
    return CategoryEntity(
       name: name ?? this.name,
       image: image ?? this.image,
       isFeatured: isFeatured ?? this.isFeatured, id: id ?? this.id,
    );
  }
}
