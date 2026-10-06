import 'package:fit_store/personalization/presentation/controllers/cart/cart_cubit.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/images/t_rounded_image.dart';
import '../../../common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import '../../../common/widgets/texts/t_product_title_text.dart';
import '../models/cart_item_model.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.item, required this.index,
  });

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
          padding: const EdgeInsets.all(TSizes.sm),
          backgroundColor: dark ? TColors.darkerGrey :
          TColors.lightGrey,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),

        // 2. تفاصيل المنتج
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const SizedBox(height: 15,),
              BrandTitleWithVerifiedIcon(title: item.brandName ?? ''),
              Flexible(child: TProductTitleText(title: item.title, maxLines: 1)),
              Text.rich(
                TextSpan(
                  children: (item.selectedVariation ?? {}).entries
                      .map(
                        (e) => TextSpan(
                      children: [
                        TextSpan(text: ' ${e.key} ', style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(text: '${e.value} ', style: Theme.of(context).textTheme.bodyLarge),
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
