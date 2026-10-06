import 'package:fit_store/features/home/data/model/product_model.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../personalization/presentation/controllers/cart/cart_cubit.dart';
import '../../../../../personalization/presentation/controllers/cart/cart_state.dart';

class ProductCardAddToCartButton extends StatelessWidget {
  const ProductCardAddToCartButton({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
         final productQuantityInCart = cartCubit.getProductQuantityInCart(product.id);

        return Container(
          decoration: BoxDecoration(
            color: productQuantityInCart > 0 ? TColors.primary : TColors.dark,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(TSizes.cardRadiusMd),
              bottomRight: Radius.circular(TSizes.productImageRadius),
            ),
          ),
          child: SizedBox(
            width: TSizes.iconLg * 1.2,
            height: TSizes.iconLg * 1.2,
            child: Center(
              child: productQuantityInCart > 0
                  ? Text(
                productQuantityInCart.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(color: TColors.white),
              )
                  : const Icon(
                Iconsax.add,
                color: TColors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}