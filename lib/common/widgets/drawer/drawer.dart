import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

 import '../../../routes/routes.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../images/t_rounded_image.dart';


class TDrawer extends StatelessWidget {
  const TDrawer({super.key});

  @override
  Widget build(BuildContext context) {


    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              TRoutes.profileScreen,
            ),
            child: Container(
              color: TColors.textDarkSecondary,
              padding: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TRoundedImage(
                  //   width: 60,
                  //   height: 60,
                  //   isNetworkImage: networkImage.isNotEmpty,
                  //   fit: BoxFit.fill,
                  //   imageUrl: image,
                  //   borderRadius: 50,
                  // ),
                  const SizedBox(height: 16),
                  Text(
                    'fullName',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TColors.dark,
                    ),
                  ),
                  Text(
                    'email',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: TColors.dark),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          ..._drawerItems(context),

          const Spacer(),
        ],
      ),
    );
  }

  List<Widget> _drawerItems(BuildContext context) {
    return [
      _buildDrawerItem(
        icon: Iconsax.user,
        title: "Profile",
        onTap: () => Navigator.pushNamed(
          context,
          TRoutes.profileScreen,
        ),
      ),
      _buildDrawerItem(
        icon: Iconsax.home,
        title: "Home",
        onTap: () => Navigator.pushNamed(
          context,
          TRoutes.home,
        ),
      ),
      _buildDrawerItem(
        icon: Iconsax.shopping_cart,
        title: "Cart",
        onTap: () => Navigator.pushNamed(
          context,
          TRoutes.cartScreen,
        ),
      ),
      _buildDrawerItem(
        icon: Iconsax.shopping_bag,
        title: "Checkout",
        onTap: () => Navigator.pushNamed(
          context,
          TRoutes.checkoutScreen,
        ),
      ),
      _buildDrawerItem(
        icon: Iconsax.heart,
        title: "Wishlist",
        onTap: () => Navigator.pushNamed(
          context,
          TRoutes.favouritesScreen,
        ),
      ),
    ];
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      onTap: onTap,
    );
  }
}