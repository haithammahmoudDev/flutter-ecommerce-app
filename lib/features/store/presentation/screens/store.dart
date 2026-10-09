import 'package:fit_store/common/widgets/brand/brandCard.dart';
import 'package:fit_store/common/widgets/layouts/grid_layout.dart';
import 'package:fit_store/common/widgets/texts/section_heading.dart';
import 'package:fit_store/features/home/domain/entities/categories_entity.dart';
import 'package:fit_store/features/home/presentation/controller/products_cubit/products_cubit.dart';
import 'package:fit_store/features/store/domain/entities/brand_entity.dart';
import 'package:fit_store/features/store/presentation/controller/brand_cubit/brand_cubit.dart';
import 'package:fit_store/features/store/presentation/widgets/gategory_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common/widgets/appbar/tabbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../cart/screens/cart_menu_icon.dart';
import '../../../home/presentation/controller/categories_cubit/categories_cubit.dart';
import '../../../home/presentation/screens/search_screen.dart';
import '../../../home/presentation/screens/widgets/header_search_container.dart';
import 'all_brands/all_brands.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});
  static const routeName = 'store_screen';

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: BlocBuilder<CategoriesCubit, CategoriesState>(
            buildWhen: (previous, current) =>
                previous.categoryEntityList != current.categoryEntityList ||
                previous.status != current.status,
            builder: (context, categoriesState) {
              final List<CategoryEntity> featuredCategories = categoriesState
                  .categoryEntityList
                  .where((e) => e.isFeatured == true)
                  .toList();

              bool isLoading =
                  categoriesState.status == CategoriesStatus.loading ||
                  (categoriesState.categoryEntityList.isEmpty &&
                      categoriesState.status != CategoriesStatus.success);

              if (isLoading) {
                final isDark = HelperFunctions.isDarkMode(context);
                return Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Expanded(
                        child: TGridLayout(
                          mainAxisExtent: 80,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: isDark
                                  ? Colors.grey[800]!
                                  : Colors.grey[300]!,
                              highlightColor: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[100]!,
                              child: RoundedContainer(
                                padding: const EdgeInsets.all(TSizes.sm),
                                showBorder: true,
                                backgroundColor: Colors.transparent,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (featuredCategories.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Iconsax.category,
                          size: 56,
                          color: TColors.darkGrey,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Text(
                          'No Categories Found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return DefaultTabController(
                key: ValueKey(featuredCategories.length),
                length: featuredCategories.length,
                child: NestedScrollView(
                  headerSliverBuilder: (_, innerBox) {
                    return [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: HelperFunctions.isDarkMode(context)
                            ? TColors.black
                            : Colors.white,
                        surfaceTintColor: Colors.transparent,
                        expandedHeight: 440,
                        pinned: true,
                        floating: false,
                        elevation: 0,
                        scrolledUnderElevation: 0,
                        centerTitle: false,
                        actionsPadding: EdgeInsets.only(right: 10),
                        title: Text(
                          'Store',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        actions: [
                          TCartCounterIcon(
                            iconColor: TColors.iconSecondaryLight,
                            counterBgColor: TColors.black,
                            counterTextColor: TColors.white,
                          ),
                        ],
                        flexibleSpace: Padding(
                          padding: const EdgeInsets.all(TSizes.defaultSpace),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: kToolbarHeight + 10),
                              TSearchContainer(
                                text: 'Search in Store',
                                showBorder: true,
                                showBackground: false,
                                onTap: (){
                                  Navigator.pushNamed(context, SearchScreen.routeName);
                                },
                              ),
                              const SizedBox(height: TSizes.spaceBtwItems),
                              SectionHeading(
                                title: 'Featured Brands',
                                onPressed: () {
                                  final brandCubit = context.read<BrandCubit>();
                                  final productsCubit = context
                                      .read<ProductsCubit>();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(value: brandCubit),
                                          BlocProvider.value(
                                            value: productsCubit,
                                          ),
                                        ],
                                        child: const AllBrandsScreen(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: TSizes.spaceBtwItems / 1.5,
                              ),
                              BlocBuilder<BrandCubit, BrandState>(
                                buildWhen: (previous, current) =>
                                    previous.featuredStatus !=
                                        current.featuredStatus ||
                                    previous.featuredBrands !=
                                        current.featuredBrands,
                                builder: (context, state) {
                                  if (state.featuredStatus ==
                                      FeaturedBrandsStatus.loading) {
                                    final isDark = HelperFunctions.isDarkMode(
                                      context,
                                    );
                                    return TGridLayout(
                                      mainAxisExtent: 80,
                                      itemCount: 4,
                                      itemBuilder: (context, index) {
                                        return Shimmer.fromColors(
                                          baseColor: isDark
                                              ? Colors.grey[800]!
                                              : Colors.grey[300]!,
                                          highlightColor: isDark
                                              ? Colors.grey[700]!
                                              : Colors.grey[100]!,
                                          child: RoundedContainer(
                                            padding: const EdgeInsets.all(
                                              TSizes.sm,
                                            ),
                                            showBorder: true,
                                            backgroundColor: Colors.transparent,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 56,
                                                  height: 56,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  if (state.featuredStatus ==
                                      FeaturedBrandsStatus.error) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: TSizes.spaceBtwItems * 1.5,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Iconsax.warning_2,
                                              size: 36,
                                              color: TColors.darkGrey,
                                            ),
                                            const SizedBox(
                                              height: TSizes.spaceBtwItems / 2,
                                            ),
                                            Text(
                                              state.errorMessage ??
                                                  'Could not load featured brands.',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: TColors.darkGrey,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  final List<BrandEntity> featuredBrands =
                                      state.featuredBrands;

                                  if (featuredBrands.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return TGridLayout(
                                    mainAxisExtent: 80,
                                    itemCount: featuredBrands.length > 4
                                        ? 4
                                        : featuredBrands.length,
                                    itemBuilder: (context, index) => Brandcard(
                                      brand: featuredBrands[index],
                                      showBorder: true,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(kToolbarHeight),
                          child: ColoredBox(
                            color: HelperFunctions.isDarkMode(context)
                                ? TColors.black
                                : Colors.white,
                            child: TTabBar(
                              tabs: featuredCategories
                                  .map(
                                    (category) =>
                                        Tab(child: Text(category.name)),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: TabBarView(
                      children: featuredCategories.map((category) {
                        return CategoryTab(category: category);
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
