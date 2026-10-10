import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class TSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: AppSizes.appBarHeight,
    left: AppSizes.defaultSpace,
    bottom: AppSizes.defaultSpace,
    right: AppSizes.defaultSpace,
  );
  static const EdgeInsetsGeometry paddingWithDefaultWidth = EdgeInsets.only(
    left: AppSizes.defaultSpace,
    right: AppSizes.defaultSpace,
  );

  static const EdgeInsetsGeometry paddingOnlyVertical = EdgeInsets.symmetric(
    vertical: AppSizes.defaultSpace,
  );

  static const EdgeInsetsGeometry paddingWithDefaultHeight = EdgeInsets.only(
    top: AppSizes.defaultSpace,
    left: AppSizes.defaultSpace,
    bottom: AppSizes.defaultSpace,
    right: AppSizes.defaultSpace,
  );
}
