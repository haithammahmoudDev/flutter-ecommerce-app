import 'package:fit_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/image_strings.dart';
import 'package:fit_store/utils/constants/sizes.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../domain/entities/reviews_entity.dart';
import '../../../controller/reviews_cubit/reviews_cubit.dart';
import 'edit_review_bottom_sheet.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key, required this.review});

  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final bool dark = HelperFunctions.isDarkMode(context);

    final formattedDate = DateFormat('dd MMM, yyyy').format(review.createdAt);
    final formattedStoreResponseDate = review.storeResponseDate != null
        ? DateFormat('dd MMM, yyyy').format(review.storeResponseDate!)
        : '';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: review.userImage.isNotEmpty
                      ? NetworkImage(review.userImage) as ImageProvider
                      : const AssetImage(TImages.tUserProfileImage),
                ),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text(
                  review.userName.isNotEmpty ? review.userName : 'Anonymous',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            // 👈 قائمة منسدلة للتحكم في التعديل والحذف
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  // فتح نافذة التعديل
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<ReviewsCubit>(context),
                      child: EditReviewBottomSheet(review: review),
                    ),
                  );
                } else if (value == 'delete') {
                  // تنفيذ الحذف مباشرة عبر الـ Cubit
                  context.read<ReviewsCubit>().deleteReview(
                    reviewId: review.id,
                    productId: review.productId, context: context,
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Iconsax.edit, size: 18),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Iconsax.trash, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Row(
          children: [
            RatingBarIndicator(
              rating: review.rating,
              itemSize: 20,
              unratedColor: TColors.grey,
              itemBuilder: (BuildContext context, int index) {
                return const Icon(Iconsax.star1, color: TColors.primary);
              },
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        ReadMoreText(
          review.comment,
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: ' show less',
          trimCollapsedText: ' show more',
          moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
          lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        if (review.storeResponse != null && review.storeResponse!.isNotEmpty)
          RoundedContainer(
            backgroundColor: dark ? TColors.darkGrey : TColors.grey,
            child: Padding(
              padding: const EdgeInsets.all(TSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fit Store', style: Theme.of(context).textTheme.titleLarge),
                      Text(formattedStoreResponseDate, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ReadMoreText(
                    review.storeResponse!,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimExpandedText: ' show less',
                    trimCollapsedText: ' show more',
                    moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
                    lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }
}