import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
    this.width = 70,
    this.height = 70,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.fill,
    this.padding = AppSizes.sm,
    this.isNetworkImage = false,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
         color: backgroundColor ??
            (HelperFunctions.isDarkMode(context) ? AppColors.black : AppColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: isNetworkImage
              ? CachedNetworkImage(
            imageUrl: image,
            width: width,
            height: height,
            fit: fit,
            color: overlayColor,
            placeholder: (context, url) => const SizedBox(
              width: 24,
              height: 24,
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.person),
          )
              : Image(
            fit: fit,
            image: AssetImage(image),
            color: overlayColor,
          ),
        ),
      ),
    );
  }
}