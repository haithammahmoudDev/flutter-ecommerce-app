import 'package:fit_store/common/widgets/appbar/appbar.dart';
import 'package:fit_store/features/home/presentation/screens/product_reviews/widgets/overall_product_rating.dart';
import 'package:fit_store/features/home/presentation/screens/product_reviews/widgets/user_review_card.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../../domain/entities/product_entity.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key, required this.product});
  static const routeName = 'productReviewsScreen';
  final ProductEntity product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
          title: Text('Reviews & Rating'),
          showActions: false,
          showSkipButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ratings and reviews are verified and are from people who use the same type of device that you use."),
              const SizedBox(height: TSizes.spaceBtwItems),
              OverallProductRating(),
              RatingBarIndicator(
                rating: 3.5,
                itemSize: 28,
                unratedColor: TColors.grey,
                itemBuilder: (BuildContext context, int index) {
                return Icon(Iconsax.star1, color: TColors.primary,);
              },),
              Text('12,061', style: Theme.of(context).textTheme.bodySmall,),
              const SizedBox(height: TSizes.defaultSpace,),
              UserReviewCard(),
              UserReviewCard(),
              UserReviewCard(),
              UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
