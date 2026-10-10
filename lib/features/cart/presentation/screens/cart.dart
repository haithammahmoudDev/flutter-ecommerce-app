import 'package:fit_store/features/checkout/presentation/screens/checkout.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../controllers/cart/cart_cubit.dart';
import '../controllers/cart/cart_state.dart';
import 'widgets/cart_items.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const String routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBarCustom(
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
                padding: const EdgeInsets.all(AppSizes.defaultSpace),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                     const Icon(
                      Icons.shopping_cart_outlined,
                      size: 100,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: AppSizes.spaceBtwItems),
                     Text(
                      'Whoops! Cart is EMPTY...',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceBtwSections),
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
            padding: EdgeInsets.all(AppSizes.defaultSpace),

             child: CartItems(),
          );
        },
      ),

       bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.all(AppSizes.defaultSpace),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, CheckoutScreen.routeName),
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
