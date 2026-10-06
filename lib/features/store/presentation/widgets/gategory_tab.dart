import 'package:fit_store/features/home/domain/entities/categories_entity.dart';
import 'package:fit_store/features/home/presentation/screens/all_products/all_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../home/presentation/controller/all_products/all_products_cubit.dart';
import '../../../home/presentation/screens/product_cards/product_card_vertical.dart';
import '../controller/brand_cubit/brand_cubit.dart';
import 'category_brand.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key, required this.category});

  final CategoryEntity category;

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // جلب المنتجات المحدودة (4 عناصر فقط) للـ Preview عبر BrandCubit
    context.read<BrandCubit>().fetchLimitedProductsForCategory(
      categoryId: widget.category.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              CategoryBrands(category: widget.category),
              const SizedBox(height: TSizes.spaceBtwItems),

              SectionHeading(
                title: 'You might like',
                onPressed: () {
                  final allProductsCubit = context.read<AllProductsCubit>();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllProducts(
                        title: widget.category.name,
                        fetchProductsFuture: () =>
                            allProductsCubit.fetchProductsForCategory(
                              categoryId: widget.category.id,
                            ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              BlocBuilder<BrandCubit, BrandState>(
                builder: (context, state) {
                  final products =
                      state.categoryProductsMap[widget.category.id];

                  if (products == null) {
                    return TGridLayout(
                      itemCount: 4,
                      itemBuilder: (_, index) =>
                          const TShimmerEffect(width: 180, height: 260),
                    );
                  }

                  if (products.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return TGridLayout(
                    itemCount: products.length,
                    itemBuilder: (_, index) =>
                        TProductCardVertical(product: products[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
