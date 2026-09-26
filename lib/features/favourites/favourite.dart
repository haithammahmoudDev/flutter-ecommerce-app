import 'package:fit_store/common/widgets/appbar/appbar.dart';
import 'package:fit_store/common/widgets/icons/t_circular_icon.dart';
import 'package:fit_store/common/widgets/layouts/grid_layout.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../home/presentation/controller/favorites_cubit/favorites_cubit.dart';
import '../home/presentation/controller/favorites_cubit/favorites_state.dart';
import '../home/presentation/screens/home.dart';
import '../home/presentation/screens/product_cards/product_card_vertical.dart';
import '../home/presentation/screens/widgets/vertical_products_shimmer.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    // جلب المفضلة عند الدخول لأول مرة
    context.read<FavoritesCubit>().fetchFavoriteProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          TCircularIcon(
            icon: Iconsax.add,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            ),
          ),
        ],
        showActions: false,
        showSkipButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Products Grid with BlocBuilder
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  // Initial + Loading States
                  if (state.status == FavoritesStatus.initial ||
                      state.status == FavoritesStatus.loading) {
                    return const TVerticalProductShimmer(itemCount: 6);
                  }

                  // Error State
                  if (state.status == FavoritesStatus.error) {
                    return Center(
                      child: Text(
                        state.errorMessage ??
                            'Something went wrong. Please try again.',
                      ),
                    );
                  }

                  // Empty State
                  if (state.favoriteProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: TSizes.spaceBtwSections),
                          const Icon(
                            Iconsax.heart_slash,
                            size: 100,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          Text(
                            'Whoops! Wishlist is Empty...',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // Success State with products
                  return TGridLayout(
                    itemCount: state.favoriteProducts.length,
                    itemBuilder: (_, index) => TProductCardVertical(
                      product: state.favoriteProducts[index],
                    ),
                  );
                },
              ),
              SizedBox(
                height: TDeviceUtils.getBottomNavigationBarHeight() +
                    TSizes.defaultSpace,
              ),
            ],
          ),
        ),
      ),
    );
  }
}