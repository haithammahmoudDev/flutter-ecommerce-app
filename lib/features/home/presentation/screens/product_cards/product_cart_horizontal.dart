import 'package:fit_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fit_store/common/widgets/images/t_rounded_image.dart';
import 'package:fit_store/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:fit_store/common/widgets/texts/t_product_title_text.dart';
import 'package:fit_store/features/home/domain/entities/product_entity.dart';
import 'package:fit_store/features/home/presentation/screens/favourite_icon.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../controller/products_cubit/products_cubit.dart';
import '../product_detail/product_detail.dart';

class TProductCardHorizontal extends StatelessWidget {
  const TProductCardHorizontal({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final productsCubit = context.read<ProductsCubit>();

    final bool isVariable =
        product.productVariations != null && product.productVariations!.isNotEmpty;

    final String displayPrice = productsCubit.getProductPrice(product);

    bool hasDiscount = false;
    String? salePercentage;

    // --- منطق حساب نسبة الخصم ---
    if (isVariable) {
      Set<int> percentages = {};
      for (var v in product.productVariations!) {
        if (v.salePrice != null && v.salePrice! > 0 && v.salePrice! < v.price) {
          hasDiscount = true;
          int pct = (((v.price - v.salePrice!) / v.price) * 100).round();
          percentages.add(pct);
        }
      }
      if (hasDiscount && percentages.isNotEmpty) {
        var sorted = percentages.toList()..sort();
        if (sorted.length == 1 || sorted.first == sorted.last) {
          salePercentage = '${sorted.first}%';
        } else {
          salePercentage = '${sorted.first}% - ${sorted.last}%';
        }
      }
    } else {
      hasDiscount = product.salePrice != null &&
          product.salePrice! > 0 &&
          product.salePrice! < product.price;
      if (hasDiscount) {
        salePercentage = productsCubit.calculateSalePercentage(product.price, product.salePrice);
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return BlocProvider.value(
            value: context.read<ProductsCubit>(),
            child: ProductDetailScreen(product: product),
          );
        }));
      },
      child: Container(
        width: 322,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.softGrey,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                RoundedContainer(
                  height: 120,
                  padding: const EdgeInsets.all(TSizes.sm),
                  backgroundColor: dark ? TColors.dark : TColors.lightGrey,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: TRoundedImage(
                          imageUrl: product.thumbnail,
                          applyImageRadius: true,
                          isNetworkImage: true,
                        ),
                      ),

                       if (salePercentage != null && salePercentage.isNotEmpty)
                        Positioned(
                          top: 1,
                          left: 0,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 75),
                            child: RoundedContainer(
                              radius: TSizes.sm,
                              backgroundColor: TColors.primary.withValues(alpha: 0.8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: TSizes.xs,
                                vertical: TSizes.xs,
                              ),
                              child: Text(
                                salePercentage.endsWith('%')
                                    ? salePercentage
                                    : '$salePercentage%',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .apply(color: TColors.black),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: TSizes.sm, left: TSizes.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             TProductTitleText(
                              title: product.title,
                              smallSize: true,
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems / 2),
                            if (product.brand != null)
                              BrandTitleWithVerifiedIcon(title: product.brand!.name),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isVariable && hasDiscount)
                                    Padding(
                                      padding: const EdgeInsets.only(left: TSizes.xs),
                                      child: Text(
                                        '\$${product.price}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .apply(
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: TSizes.xs),
                                    child: Text(
                                      displayPrice,
                                      style: Theme.of(context).textTheme.titleMedium!.apply(
                                        color: dark ? TColors.white : TColors.dark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: TColors.dark,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(TSizes.cardRadiusMd),
                                  bottomRight: Radius.circular(
                                    TSizes.productImageRadius,
                                  ),
                                ),
                              ),
                              child: const SizedBox(
                                width: TSizes.iconLg * 1.2,
                                height: TSizes.iconLg * 1.2,
                                child: Center(
                                  child: Icon(Iconsax.add, color: TColors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

             Positioned(
              top: 30,
              right: 0,
              child: TFavouriteIcon(productId: product.id),
            ),
          ],
        ),
      ),
    );
  }
}