import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import '../../../../common/widgets/texts/t_product_title_text.dart';
import '../../data/models/cart_item_model.dart';
import '../controllers/cart/cart_cubit.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.item, required this.index});

  final CartItemModel item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TRoundedImage(
          width: 80,
          height: 80,
          imageUrl: item.image ?? '',
          isNetworkImage: true,
          padding: const EdgeInsets.all(AppSizes.sm),
          backgroundColor: dark ? AppColors.darkerGrey : AppColors.lightGrey,
        ),
        const SizedBox(width: AppSizes.spaceBtwItems),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              BrandTitleWithVerifiedIcon(title: item.brandName ?? ''),
              Flexible(
                child: TProductTitleText(title: item.title, maxLines: 1),
              ),
              Text.rich(
                TextSpan(
                  children: (item.selectedVariation ?? {}).entries
                      .map(
                        (e) => TextSpan(
                          children: [
                            TextSpan(
                              text: ' ${e.key} ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: '${e.value} ',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            context.read<CartCubit>().removeFromCartDialog(index, context);
          },
          padding: EdgeInsets.zero,
          icon: const Icon(Iconsax.trash, color: Colors.red),
        ),
      ],
    );
  }
}
