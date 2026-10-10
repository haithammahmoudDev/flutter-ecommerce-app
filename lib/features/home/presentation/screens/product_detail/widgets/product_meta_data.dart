import 'package:fit_store/features/home/presentation/controller/products_cubit/products_cubit.dart';
import 'package:fit_store/features/home/presentation/controller/products_cubit/variation_cubit.dart';
import 'package:fit_store/features/home/presentation/controller/products_cubit/variation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../../common/widgets/images/t_circular_image.dart';
import '../../../../../../common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import '../../../../../../common/widgets/texts/t_product_price_text.dart';
import '../../../../../../common/widgets/texts/t_product_title_text.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/product_entity.dart';

class ProductMetaData extends StatelessWidget {
  const ProductMetaData({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
     final ProductsCubit productsCubit = context.read<ProductsCubit>();

    return BlocBuilder<VariationCubit, VariationState>(
      builder: (context, variationState) {
         final bool isSelected = variationState.isVariationFullySelected;

         final double effectivePrice = isSelected
            ? variationState.selectedVariation.price
            : product.price;

        final double? effectiveSalePrice = isSelected
            ? variationState.selectedVariation.salePrice
            : product.salePrice;

         final bool hasSale = isSelected
            ? (effectiveSalePrice != null && effectiveSalePrice > 0 && effectiveSalePrice < effectivePrice)
            : (product.productVariations != null &&
             product.productVariations!.any((v) => v.salePrice != null && v.salePrice! > 0 && v.salePrice! < v.price));

         final salePercentage = productsCubit.calculateSalePercentage(
          effectivePrice,
          effectiveSalePrice,
        );

         final String finalDisplayPrice = isSelected
            ? (effectiveSalePrice != null && effectiveSalePrice > 0
            ? effectiveSalePrice.toString()
            : effectivePrice.toString())
            : productsCubit.getProductPrice(product);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                 if (salePercentage != null &&
                     salePercentage.isNotEmpty &&
                     (isSelected ? (effectiveSalePrice != null &&
                         effectiveSalePrice > 0) : true)) ...[
                  RoundedContainer(
                    backgroundColor: AppColors.primary,
                    radius: AppSizes.sm,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    child: Text(
                      '$salePercentage%',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .apply(color: AppColors.black),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceBtwItems),
                ],

                 if (hasSale) ...[
                  Text(
                    isSelected
                        ? '\$$effectivePrice'
                        : productsCubit.getProductOriginalPriceRange(product),
                    style: Theme.of(context).textTheme.titleSmall!.apply(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceBtwItems),
                ],

                 ProductPriceText(
                  price: finalDisplayPrice,
                  isLarge: true,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceBtwItems / 1.5),
            TProductTitleText(title: product.title),
            const SizedBox(height: AppSizes.spaceBtwItems / 1.5),
            Row(
              children: [
                const TProductTitleText(title: 'Stock : ', smallSize: true),
                Text(
                  isSelected
                      ? variationState.variationStockStatus
                      : productsCubit.getProductStockStatus(product.stock),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceBtwItems / 2),
            Row(
              spacing: 3,
              children: [
                CircularImage(
                  image: product.brand != null ? product.brand!.image : '',
                  width: 35,
                  height: 35,
                  padding: 4,
                  isNetworkImage: true,
                  fit: BoxFit.contain,
                  backgroundColor: Colors.white,
                ),
                BrandTitleWithVerifiedIcon(
                  title: product.brand != null ? product.brand!.name : '',
                  brandTextSize: TextSizes.medium,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}