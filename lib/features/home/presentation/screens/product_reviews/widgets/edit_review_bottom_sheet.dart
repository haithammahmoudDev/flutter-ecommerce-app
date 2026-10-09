import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/reviews_entity.dart';
import '../../../controller/reviews_cubit/reviews_cubit.dart';

class EditReviewBottomSheet extends StatefulWidget {
  const EditReviewBottomSheet({super.key, required this.review});

  final ReviewEntity review;

  @override
  State<EditReviewBottomSheet> createState() => _EditReviewBottomSheetState();
}

class _EditReviewBottomSheetState extends State<EditReviewBottomSheet> {
  late double _rating;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _rating = widget.review.rating;
    _commentController = TextEditingController(text: widget.review.comment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: TSizes.defaultSpace,
        right: TSizes.defaultSpace,
        top: TSizes.defaultSpace,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Your Review', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: TSizes.spaceBtwItems),

            // اختيار النجوم المعدلة مسبقاً
            Center(
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 36,
                itemBuilder: (context, _) => const Icon(
                  Iconsax.star1,
                  color: TColors.primary,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // حقل تعديل التعليق
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Update your review here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // زر التحديث
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_commentController.text.trim().isEmpty) return;

                  final updatedReview = ReviewEntity(
                    id: widget.review.id,
                    productId: widget.review.productId,
                    userId: widget.review.userId,
                    userName: widget.review.userName,
                    userImage: widget.review.userImage,
                    rating: _rating,
                    comment: _commentController.text.trim(),
                    createdAt: widget.review.createdAt,
                  );

                  // استدعاء دالة التحديث في الـ Cubit
                  context.read<ReviewsCubit>().updateReview(updatedReview, context);

                  // إغلاق النافذة
                  Navigator.pop(context);
                },
                child: const Text('Update Review'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}