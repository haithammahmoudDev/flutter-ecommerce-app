import 'package:fit_store/features/home/presentation/controller/categories_cubit/categories_cubit.dart';
import 'package:fit_store/features/home/presentation/controller/products_cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../common/widgets/image_text/image_text_vertical.dart';
import '../../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../common/di/injection_container.dart';
import '../sub_categories/sub_categories.dart';

class THeaderCategories extends StatelessWidget {
  const THeaderCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<CategoriesCubit>(),
  child: Padding(
      padding: const EdgeInsets.only(left: AppSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            title: 'Popular Categories',
            textColor: AppColors.white,
            showActionButton: false,
          ),
          const SizedBox(height: AppSizes.spaceBtwItems),

          SizedBox(
            height: 80,
            child: BlocBuilder<CategoriesCubit, CategoriesState>(
              builder: (context, state) {
                 switch (state.status) {
                   case CategoriesStatus.loading:
                    return const TCategoryShimmerList();

                  case CategoriesStatus.success:
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categoryEntityList.length,
                      separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceBtwItems),
                      itemBuilder: (_, index) {
                        final category = state.categoryEntityList[index];
                        return TVerticalImageAndText(
                          image: category.image,
                          title: category.name,
                          onTap: () {

                               final productsCubit = context.read<ProductsCubit>();
                               final categoryCubit = context.read<CategoriesCubit>();
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => MultiBlocProvider(
                                     providers: [
                                        BlocProvider.value(value: productsCubit),
                                        BlocProvider.value(value: categoryCubit),
                                     ],
                                     child: SubCategoriesScreen(category: category),
                                   ),
                                 ),
                               );


                          },
                        );
                      },
                    );

                  case CategoriesStatus.error:
                    return Center(child: Text(state.errorMessage ?? 'An error occurred'));
                }
              },
            ),
          ),
        ],
      ),
    ),
);
  }
}

class TCategoryShimmerList extends StatelessWidget {
  const TCategoryShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceBtwItems),
      itemBuilder: (_, __) {
        return const Column(
          children: [
            TShimmerEffect(width: 56, height: 56, radius: 56),
            SizedBox(height: AppSizes.spaceBtwItems / 2),
            TShimmerEffect(width: 55, height: 8, radius: 4),
          ],
        );
      },
    );
  }
}

class TShimmerEffect extends StatelessWidget {
  const TShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
    this.color,
  });

  final double width, height, radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
