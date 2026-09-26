import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../../../personalization/presentation/controllers/cart/cart_cubit.dart';
import '../../../../../../personalization/presentation/controllers/cart/cart_state.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../data/model/product_model.dart';


class BottomAddToCart extends StatelessWidget {
  const BottomAddToCart({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

     context.read<CartCubit>().updateAlreadyAddedProductCount(product, context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.defaultSpace / 2,
      ),
      decoration: BoxDecoration(
        color: dark ? TColors.darkerGrey : TColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TSizes.cardRadiusLg),
          topRight: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cartCubit = context.read<CartCubit>();
          final quantity = state.productQuantityInCart;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   TCircularIcon(
                    icon: Iconsax.minus,
                    backgroundColor: TColors.darkGrey,
                    width: 40,
                    height: 40,
                    color: TColors.white,
                    onPressed: quantity < 1
                        ? null
                        : () => cartCubit.decrementProductQuantity(),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                   Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                   TCircularIcon(
                    icon: Iconsax.add,
                    backgroundColor: TColors.black,
                    width: 40,
                    height: 40,
                    color: TColors.white,
                    onPressed: () => cartCubit.incrementProductQuantity(),
                  ),
                ],
              ),

               ElevatedButton(
                onPressed: quantity < 1
                    ? null
                    : () =>
                    cartCubit.addToCart(product, context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(TSizes.md),
                  backgroundColor: TColors.black,
                  side: const BorderSide(color: TColors.black),
                ),
                child: const Text('Add to Cart'),
              ),
            ],
          );
        },
      ),
    );
  }
}