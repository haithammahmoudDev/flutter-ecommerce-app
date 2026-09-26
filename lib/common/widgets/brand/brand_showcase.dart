// Path in project: lib/common/widgets/brand/brand_showcase.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_store/features/home/presentation/controller/products_cubit/products_cubit.dart';
import 'package:fit_store/features/store/presentation/controller/brand_cubit/brand_cubit.dart';
import 'package:fit_store/features/store/presentation/screens/all_brands/brand_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/store/domain/entities/brand_entity.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../shimmers/shimmer.dart';
import 'brandCard.dart';

class TBrandShowcase extends StatelessWidget {
  const TBrandShowcase({
    super.key,
    required this.brand,
    required this.images,
  });

  final BrandEntity brand;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    // تصفية الصور للتأكد من أنها صالحة وليست فارغة
    final validImages = images.where((image) => image.isNotEmpty).toList();

    // إذا لم تكن هناك أي صور نهائياً، قم بإخفاء الكارت بالكامل
    if (validImages.isEmpty) {
      return const SizedBox.shrink();
    }

    // تجهيز 3 خانات ثابتة لتنسيق الشكل، وإكمال الخانات الناقصة بنصوص فارغة
    final paddedImages = List.generate(
      3,
          (index) => index < validImages.length ? validImages[index] : '',
    );

    return RoundedContainer(
      showBorder: true,
      borderColor: TColors.darkGrey,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.all(TSizes.md),
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Column(
        children: [
          /// -- Brand header with product count and proper cubit provisioning.
          Brandcard(
            showBorder: false,
            brand: brand,
            onTap: () {
              final brandCubit = context.read<BrandCubit>();
              final productsCubin = context.read<ProductsCubit>();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: brandCubit),
                      BlocProvider.value(value: productsCubin),
                    ],
                    child: BrandProducts(brand: brand),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// -- Up to 3 product thumbnails (with empty padding for missing slots).
          Row(
            children: paddedImages.map((image) {
              if (image.isEmpty) {
                // 💡 خانة فارغة شفافة تماماً بدون أي شيمر أو مربعات رمادية
                return Expanded(
                  child: Container(
                    height: 100,
                    margin: const EdgeInsets.only(right: TSizes.sm),
                  ),
                );
              }
              return _productThumbnail(context, image);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _productThumbnail(BuildContext context, String image) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    return Expanded(
      child: RoundedContainer(
        height: 100,
        padding: const EdgeInsets.all(TSizes.md),
        margin: const EdgeInsets.only(right: TSizes.sm),
        backgroundColor: isDark ? TColors.disabledBackgroundLight : TColors.disabledBackgroundLight,
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: image,
          progressIndicatorBuilder: (context, url, downloadProgress) => const TShimmerEffect(width: 100, height: 100),
          errorWidget: (context, url, error) => const Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }
}