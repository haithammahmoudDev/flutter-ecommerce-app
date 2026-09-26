import 'package:fit_store/common/widgets/loaders/animation_loader.dart';
import 'package:fit_store/features/cart/controllers/cart_cubit.dart';
import 'package:fit_store/features/cart/controllers/cart_state.dart';
import 'package:fit_store/navigation_menu.dart';
import 'package:fit_store/utils/constants/image_strings.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../../../personalization/presentation/controllers/cart/cart_cubit.dart';
import '../../../personalization/presentation/controllers/cart/cart_state.dart';
import '../../../routes/routes.dart';
import 'widgets/cart_items.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: TAppBar(
        showBackArrow: true,
        title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
        showActions: false,
        showSkipButton: false,
      ),

       body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                     const Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                     Text(
                      'Whoops! Cart is EMPTY...',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                     SizedBox(
                      width: 200,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.add_shopping_cart_rounded),
                        label: const Text("Let's fill it"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),

             child: CartItems(),
          );
        },
      ),

       bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, TRoutes.checkoutScreen),
                child: Text(
                  'Checkout \$${state.totalCartPrice.toStringAsFixed(1)}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
