import 'package:fit_store/common/widgets/appbar/home_appbar.dart';
import 'package:fit_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fit_store/features/checkout/screens/widgets/billing_address_section.dart';
import 'package:fit_store/features/checkout/screens/widgets/billing_payment_section.dart';
import 'package:fit_store/features/home/presentation/controller/checkout/checkout_cubit.dart';
import 'package:fit_store/features/home/presentation/controller/checkout/checkout_state.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:fit_store/utils/helpers/pricing_calculator.dart';
import 'package:fit_store/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/di/injection_container.dart';
import '../../../personalization/presentation/controllers/cart/cart_cubit.dart';
import '../../../personalization/presentation/controllers/cart/cart_state.dart';
import '../../../personalization/presentation/controllers/order/order_cubit.dart';
import '../../cart/screens/widgets/cart_items.dart';
import 'billing_amount_section.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CheckoutCubit>()),
        BlocProvider(create: (_) => sl<OrderCubit>()),
      ],
      child: Scaffold(
        appBar: const TEComAppBar(
          title: Text('Order Review'),
          showBackArrow: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CartItems(showAddRemoveButtons: false),
                const SizedBox(height: TSizes.spaceBtwSections),

                RoundedContainer(
                  borderColor: TColors.dashboardAppbarBackground,
                  showBorder: true,
                  padding: const EdgeInsets.all(TSizes.md),
                  backgroundColor: dark ? TColors.black : TColors.white,
                  child: const Column(
                    children: [
                      BillingAmountSection(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      Divider(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      BillingPaymentSection(),
                      SizedBox(height: TSizes.spaceBtwSections),

                      BillingAddressSection(),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ),

        bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            final subTotal = cartState.totalCartPrice;
            final totalAmount = TPricingCalculator.calculateTotalPrice(subTotal, 'US');

            return Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: subTotal > 0
                      ? () {
                    context.read<OrderCubit>().processOrder(
                      context: context,
                      totalAmount: totalAmount,
                    );
                  }
                      : () {
                    Loaders.warningSnackBar(
                      title: 'Empty Cart',
                      message: 'Add items in the cart in order to proceed.',
                      context: context,
                    );
                  },
                  child: Text('Checkout \$$totalAmount'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}