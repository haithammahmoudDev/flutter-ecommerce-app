import 'package:fit_store/routes/routes.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../personalization/presentation/controllers/cart/cart_cubit.dart';
import '../../../personalization/presentation/controllers/cart/cart_state.dart';
import '../controllers/cart_cubit.dart';
import '../controllers/cart_state.dart';

/// Custom widget for the cart counter icon
class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key,
    this.iconColor,
    this.counterBgColor,
    this.counterTextColor,
  });

  final Color? iconColor;
  final Color? counterBgColor;
  final Color? counterTextColor;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Stack(
      children: [
        IconButton(
          onPressed: () => Navigator.pushNamed(
            context,
            TRoutes.cartScreen,
          ),
          icon: Icon(
            Iconsax.shopping_bag,
            color: iconColor,
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            width: TSizes.fontSizeLg,
            height: TSizes.fontSizeLg,
            decoration: BoxDecoration(
              color: counterBgColor ?? (dark ? TColors.white : TColors.black),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              // استخدام BlocBuilder لمراقبة التغير في noOfCartItems
              child: BlocBuilder<CartCubit, CartState>(
                buildWhen: (previous, current) =>
                previous.noOfCartItems != current.noOfCartItems,
                builder: (context, state) {
                  return Text(
                    state.noOfCartItems.toString(),
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                      color: counterTextColor ??
                          (dark ? TColors.black : TColors.white),
                      fontSizeFactor: 0.8,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}