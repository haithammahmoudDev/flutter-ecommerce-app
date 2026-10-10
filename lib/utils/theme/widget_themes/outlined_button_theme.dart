import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';


class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

   static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.secondary,
      side: const BorderSide(color: AppColors.secondary),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg)),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.white),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg)),
    ),
  );
}
