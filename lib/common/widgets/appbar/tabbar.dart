import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class TTabBar extends StatelessWidget implements PreferredSizeWidget {
  const TTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return Material(
      color: dark ? AppColors.black : Colors.white,
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start, // 💡 هذا هو السطر الذي يزيل المسافة الفارغة ويجعلها تبدأ من أقصى اليسار تماماً
        indicatorColor: AppColors.primary,
        labelColor: dark ? AppColors.white : AppColors.primary,
        unselectedLabelColor: AppColors.darkGrey,
        tabs: tabs,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}