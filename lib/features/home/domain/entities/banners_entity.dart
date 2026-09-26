class BannerEntity {
  final String imageUrl;
  final String targetScreen;
  final bool active;

  const BannerEntity({
    required this.imageUrl,
    required this.targetScreen,
    required this.active,
  });
}