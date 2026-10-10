import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../cart/presentation/controllers/cart/cart_cubit.dart';
import '../../../../../cart/presentation/controllers/cart/cart_state.dart';
import '../../../../data/model/product_model.dart';


class BottomAddToCart extends StatelessWidget {
  const BottomAddToCart({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

     context.read<CartCubit>().updateAlreadyAddedProductCount(product, context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.defaultSpace,
        vertical: AppSizes.defaultSpace / 2,
      ),
      decoration: BoxDecoration(
        color: dark ? AppColors.darkerGrey : AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSizes.cardRadiusLg),
          topRight: Radius.circular(AppSizes.cardRadiusLg),
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
                   CircularIcon(
                    icon: Iconsax.minus,
                    backgroundColor: AppColors.darkGrey,
                    width: 40,
                    height: 40,
                    color: AppColors.white,
                    onPressed: quantity < 1
                        ? null
                        : () => cartCubit.decrementProductQuantity(),
                  ),
                  const SizedBox(width: AppSizes.spaceBtwItems),

                   Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: AppSizes.spaceBtwItems),

                   CircularIcon(
                    icon: Iconsax.add,
                    backgroundColor: AppColors.black,
                    width: 40,
                    height: 40,
                    color: AppColors.white,
                    onPressed: () => cartCubit.incrementProductQuantity(),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: quantity < 1
                    ? null
                    : () => cartCubit.addToCart(product, context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(AppSizes.md),
                  backgroundColor: AppColors.black,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: dark ? Colors.grey : Colors.black54,
                  side: const BorderSide(color: AppColors.black),
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