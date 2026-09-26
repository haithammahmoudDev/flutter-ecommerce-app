import 'package:fit_store/features/cart/controllers/cart_cubit.dart';
import 'package:fit_store/features/cart/controllers/cart_state.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/texts/t_product_price_text.dart';
import '../../../../personalization/presentation/controllers/cart/cart_cubit.dart';
import '../../../../personalization/presentation/controllers/cart/cart_state.dart';
import '../add_remove_cart_button.dart';
import '../cart_product_style_01.dart';

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
    this.showAddRemoveButtons = true,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cartCubit = context.read<CartCubit>();

        // 1. Removed Expanded
        // 2. Added shrinkWrap and NeverScrollableScrollPhysics
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.cartItems.length,
          separatorBuilder: (_, __) =>
          const SizedBox(height: TSizes.spaceBtwSections),
          itemBuilder: (_, index) {
            final item = state.cartItems[index];

            return Column(
              children: [
                CartItem(item: item, index: index),

                if (showAddRemoveButtons)
                  const SizedBox(height: TSizes.spaceBtwItems),

                if (showAddRemoveButtons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          /// Extra Space
                          const SizedBox(width: 70),

                          /// Add Remove Buttons
                          TProductQuantityWithAddRemoveButton(
                            quantity: item.quantity,
                            add: () => cartCubit.addOneToCart(item),
                            remove: () => cartCubit.removeOneFromCart(item, context),
                          ),
                        ],
                      ),

                      /// Product total price
                      ProductPriceText(
                        price: (item.price * item.quantity).toStringAsFixed(1),
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }
}