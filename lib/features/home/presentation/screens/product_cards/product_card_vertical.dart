import 'package:fit_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fit_store/common/widgets/images/t_rounded_image.dart';
import 'package:fit_store/common/widgets/styles/shadows.dart';
import 'package:fit_store/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:fit_store/common/widgets/texts/t_product_title_text.dart';
import 'package:fit_store/features/home/domain/entities/product_entity.dart';
import 'package:fit_store/features/home/presentation/controller/products_cubit/products_cubit.dart';
import 'package:fit_store/features/home/presentation/screens/product_detail/product_detail.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/enums.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../favourite_icon.dart';
import '../widgets/product_card_add_to_cart_button.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final productsCubit = context.read<ProductsCubit>();
    final dark = HelperFunctions.isDarkMode(context);

    final bool isVariable =
        product.productVariations != null && product.productVariations!.isNotEmpty;

    bool hasDiscount = false;
    String? salePercentage;

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
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedContainer(
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.white,
              child: Stack(
                children: [
                  Center(
                    child: TRoundedImage(
                      isNetworkImage: true,
                      imageUrl: product.thumbnail,
                      applyImageRadius: true,
                    ),
                  ),
                  if (salePercentage != null && salePercentage.isNotEmpty)
                    Positioned(
                      top: 12,
                      child: RoundedContainer(
                        radius: TSizes.sm,
                        backgroundColor: TColors.primary.withValues(alpha: 0.8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.sm,
                          vertical: TSizes.xs,
                        ),
                        child: Text(
                          salePercentage.endsWith('%')
                              ? salePercentage
                              : '$salePercentage%',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .apply(color: TColors.black),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: TFavouriteIcon(productId: product.id),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(
                    title: product.title,
                    smallSize: true,
                    maxLines: 1,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  if (product.brand != null)
                    BrandTitleWithVerifiedIcon(
                      title: product.brand!.name,
                      brandTextSize: TextSizes.small,
                    ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isVariable && hasDiscount)
                        Padding(
                          padding: const EdgeInsets.only(left: TSizes.sm),
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
                        padding: const EdgeInsets.only(left: TSizes.sm),
                        child: Text(
                          productsCubit.getProductPrice(product),
                          style: Theme.of(context).textTheme.titleMedium!.apply(
                            color: TColors.dark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ProductCardAddToCartButton(product: product.toModel()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}