import 'package:fit_store/common/widgets/appbar/home_appbar.dart';
import 'package:fit_store/common/widgets/images/t_rounded_image.dart';
import 'package:fit_store/common/widgets/texts/section_heading.dart';
import 'package:fit_store/features/home/domain/entities/categories_entity.dart';
import 'package:fit_store/features/home/presentation/controller/categories_cubit/categories_cubit.dart';
import 'package:fit_store/features/home/presentation/screens/all_products/all_products.dart';
import 'package:fit_store/utils/constants/image_strings.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../product_cards/product_cart_horizontal.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({super.key, required this.category});
  static const routeName = 'sub_categories_screen';
  final CategoryEntity category;

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.category.id.isNotEmpty) {
      context.read<CategoriesCubit>().getSubcategories(categoryId: widget.category.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TEComAppBar(
        title: Text(widget.category.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TRoundedImage(
              imageUrl: TImages.promoBanner3,
              width: double.infinity,
              applyImageRadius: true,
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                if (state.subCategoriesStatus == SubCategoriesStatus.loading) {
                  return _buildCategoryShimmer();
                }
                if (state.subCategoriesStatus == SubCategoriesStatus.error) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Center(
                      child: Text(
                        state.errorMessage ?? 'Something went wrong.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                if (state.subCategories.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Center(
                      child: Text(
                        'No Sub Categories Found for "${widget.category.name}"!',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.subCategories.map((subCategory) {
                    final subProducts = state.productsFor(subCategory.id);
                    final subStatus = state.statusFor(subCategory.id);

                    if (subStatus == SubProductsCategoryStatus.success && subProducts.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (subStatus == SubProductsCategoryStatus.error) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: TSizes.spaceBtwSections),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeading(
                            title: subCategory.name,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllProducts(
                                    title: subCategory.name,
                                    fetchProductsFuture: () => context
                                        .read<CategoriesCubit>()
                                        .fetchProductsForSubCategory(
                                      subCategoryId: subCategory.id,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: TSizes.spaceBtwItems / 2),
                          switch (subStatus) {
                            SubProductsCategoryStatus.loading =>
                                _buildHorizontalProductShimmer(),
                            SubProductsCategoryStatus.success => SizedBox(
                              height: 135,
                              child: ListView.separated(
                                itemCount: subProducts.length,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                const SizedBox(width: TSizes.spaceBtwItems),
                                itemBuilder: (context, index) {
                                  return TProductCardHorizontal(
                                    product: subProducts[index],
                                  );
                                },
                              ),
                            ),
                            SubProductsCategoryStatus.error => const SizedBox.shrink(),
                          },
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(2, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: TSizes.spaceBtwSections),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 140,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              _buildHorizontalProductShimmer(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHorizontalProductShimmer() {
    return SizedBox(
      height: 135,
      child: ListView.separated(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(width: TSizes.spaceBtwItems),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 275,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(TSizes.productImageRadius),
              ),
            ),
          );
        },
      ),
    );
  }
}