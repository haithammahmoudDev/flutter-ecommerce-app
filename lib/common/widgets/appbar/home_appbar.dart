import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class TEComAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TEComAppBar({super.key, this.title, this.actions, this.leadingIcon, this.leadingOnPressed, this.showBackArrow = false});

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        leading:
            showBackArrow
                ? IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Iconsax.arrow_left, color: dark ? AppColors.white : AppColors.dark))
                : leadingIcon != null
                ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon))
                : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
