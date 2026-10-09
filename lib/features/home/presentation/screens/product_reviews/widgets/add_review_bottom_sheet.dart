import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/preferences/loacal_storage_service.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/reviews_entity.dart';
import '../../../controller/reviews_cubit/reviews_cubit.dart';

class AddReviewBottomSheet extends StatefulWidget {
  const AddReviewBottomSheet({super.key, required this.productId});

  final String productId;

  @override
  State<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends State<AddReviewBottomSheet> {
  double _rating = 5.0;
  final TextEditingController _commentController = TextEditingController();

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
            Text('Add Your Review', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: TSizes.spaceBtwItems),

            // اختيار النجوم
            Center(
              child: RatingBar.builder(
                initialRating: 5,
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

            // حقل كتابة التعليق
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Write your review here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // زر الإرسال
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_commentController.text.trim().isEmpty) return;

                  // جلب بيانات المستخدم الحالي المخزنة محلياً لتضمين اسمه وصورته
                  final currentUser = LocalStorageService.userRepo.getData();

                  final newReview = ReviewEntity(
                    id: '', // سيتم توليده تلقائياً من فايربيس عبر الـ .add()
                    productId: widget.productId,
                    userId: currentUser?.id ?? '1',
                    userName: currentUser?.fullName ?? 'User',
                    userImage: currentUser?.profilePicture ?? '',
                    rating: _rating,
                    comment: _commentController.text.trim(),
                    createdAt: DateTime.now(),
                  );

                  // استدعاء الـ Cubit لإضافة التقييم
                  context.read<ReviewsCubit>().addReview(newReview, context);

                  // إغلاق النافذة
                  Navigator.pop(context);
                },
                child: const Text('Submit Review'),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}