import 'package:fit_store/features/home/presentation/screens/product_reviews/widgets/add_review_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../controller/reviews_cubit/reviews_cubit.dart';
import 'widgets/overall_product_rating.dart';
import 'widgets/user_review_card.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key, required this.productId});

  static const routeName = 'productReviewsScreen';
  final String productId;

  @override
  Widget build(BuildContext context) {
    // 👈 لا داعي لإنشاء BlocProvider جديد هنا، لأننا استلمناه من الشاشة السابقة
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Reviews & Rating'),
        showActions: false,
        showSkipButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: context.read<ReviewsCubit>(),
              child: AddReviewBottomSheet(productId: productId),
            ),
          );
        },
        backgroundColor: TColors.primary,
        child: const Icon(Iconsax.edit, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ratings and reviews are verified and are from people who use the same type of device that you use."),
              const SizedBox(height: TSizes.spaceBtwItems),

              BlocBuilder<ReviewsCubit, ReviewsState>(
                builder: (context, state) {
                  if (state.status == ReviewsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  double averageRating = 0.0;
                  if (state.reviews.isNotEmpty) {
                    double total = 0.0;
                    for (var r in state.reviews) {
                      total += r.rating;
                    }
                    averageRating = total / state.reviews.length;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OverallProductRating(reviews: state.reviews),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      RatingBarIndicator(
                        rating: averageRating,
                        itemSize: 28,
                        unratedColor: TColors.grey,
                        itemBuilder: (BuildContext context, int index) {
                          return const Icon(Iconsax.star1, color: TColors.primary);
                        },
                      ),
                      Text(
                        '${state.reviews.length} Reviews',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      if (state.reviews.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: Text('No reviews yet for this product.')),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.reviews.length,
                          itemBuilder: (context, index) {
                            return UserReviewCard(review: state.reviews[index]);
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}