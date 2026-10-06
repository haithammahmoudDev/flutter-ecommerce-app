import 'package:fit_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:fit_store/common/widgets/texts/section_heading.dart';
import 'package:fit_store/features/home/presentation/controller/all_products/all_products_cubit.dart';
import 'package:fit_store/features/home/presentation/controller/products_cubit/products_cubit.dart';
import 'package:fit_store/features/home/presentation/screens/product_cards/product_card_vertical.dart';
import 'package:fit_store/features/home/presentation/screens/widgets/header_categories.dart';
import 'package:fit_store/features/home/presentation/screens/widgets/header_search_container.dart';
import 'package:fit_store/features/home/presentation/screens/widgets/home_appbar.dart';
import 'package:fit_store/features/home/presentation/screens/widgets/promo_slider.dart';
import 'package:fit_store/features/home/presentation/screens/widgets/vertical_products_shimmer.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/constants/text_strings.dart';
import 'package:fit_store/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/di/injection_container.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'all_products/all_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return BlocProvider(
      create: (context) => sl<ProductsCubit>()..fetchFeaturedProducts(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [

              const TPrimaryHeaderContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    HomeAppBar(),
                    SizedBox(height: TSizes.spaceBtwSections),

                    TSearchContainer(text: 'Search in Store', showBorder: false),
                    SizedBox(height: TSizes.spaceBtwSections),

                    THeaderCategories(),
                    SizedBox(height: TSizes.spaceBtwSections * 2),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// -- Promo Slider 1
                    const TPromoSlider(),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// -- Popular Products
                    /// -- Popular Products
                    /// -- Popular Products
                    SectionHeading(
                      title: AppTexts.popularProducts,
                      onPressed: () {
                        final allProductsCubit = context.read<AllProductsCubit>();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: allProductsCubit,
                              child: AllProducts(
                                title: AppTexts.popularProducts,
                                // 👈 جلب جميع المنتجات بدلاً من المصفاة فقط
                                fetchProductsFuture: () => allProductsCubit.fetchAllProducts(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    BlocBuilder<ProductsCubit, ProductsState>(
                      builder: (context, state) {
                        if (state.status == FeaturedProductsStatus.loading) {
                          return const TVerticalProductShimmer(itemCount: 4);
                        }

                        if (state.status == FeaturedProductsStatus.error) {
                          return Center(
                            child: Text(state.errorMessage ?? 'حدث خطأ ما'),
                          );
                        }

                        final popularProducts = state.featuredProducts;

                        if (popularProducts.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: TSizes.spaceBtwSections,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.bag_cross5,
                                    size: 64,
                                    color: dark ? TColors.darkGrey : TColors.grey,
                                  ),
                                  const SizedBox(height: TSizes.spaceBtwItems),
                                  Text(
                                    'لا توجد منتجات متاحة حالياً',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: dark ? TColors.grey : TColors.darkerGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return TGridLayout(
                          itemCount: popularProducts.length,
                          itemBuilder: (_, index) => TProductCardVertical(
                            product: popularProducts[index],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: TDeviceUtils.getBottomNavigationBarHeight() + TSizes.defaultSpace,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}