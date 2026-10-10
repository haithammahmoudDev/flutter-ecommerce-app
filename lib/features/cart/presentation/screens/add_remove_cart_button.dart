import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/icons/t_circular_icon.dart';


class TProductQuantityWithAddRemoveButton extends StatelessWidget {
  const TProductQuantityWithAddRemoveButton({
    super.key,
    required this.add,
    this.width = 40,
    this.height = 40,
    this.iconSize,
    required this.remove,
    required this.quantity,
    this.addBackgroundColor = AppColors.black,
    this.removeBackgroundColor = AppColors.darkGrey,
    this.addForegroundColor = AppColors.white,
    this.removeForegroundColor = AppColors.white,
  });

  final VoidCallback? add, remove;
  final int quantity;
  final double width, height;
  final double? iconSize;
  final Color addBackgroundColor, removeBackgroundColor;
  final Color addForegroundColor, removeForegroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircularIcon(
          icon: Iconsax.minus,
          onPressed: remove,
          width: width,
          height: height,
          size: iconSize,
          color: removeForegroundColor,
          backgroundColor: removeBackgroundColor,
        ),
        const SizedBox(width: AppSizes.spaceBtwItems),
        Text(quantity.toString(), style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: AppSizes.spaceBtwItems),
        CircularIcon(
          icon: Iconsax.add,
          onPressed: add,
          width: width,
          height: height,
          size: iconSize,
          color: addForegroundColor,
          backgroundColor: addBackgroundColor,
        ),
      ],
    );
  }
}
