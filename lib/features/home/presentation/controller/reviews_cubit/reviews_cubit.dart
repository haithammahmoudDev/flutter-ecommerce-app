import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit_store/features/home/domain/entities/reviews_entity.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../common/preferences/loacal_storage_service.dart';
import '../../../../../utils/helpers/network_manager.dart';
import '../../../../../utils/popups/full_screen_loader.dart';
import '../../../data/repos/review_repo.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final ReviewsRepo _reviewsRepo;

  ReviewsCubit({required ReviewsRepo reviewsRepo})
      : _reviewsRepo = reviewsRepo,
        super(const ReviewsState());

  /// جلب التقييمات الخاصة بمنتج معين (مع دعم الكاش المحلي والأوفلاين)
  Future<void> fetchReviewsForProduct(String productId) async {
    emit(state.copyWith(status: ReviewsStatus.loading));

    final String cacheKey = 'reviews_$productId';
    final cachedReviews = LocalStorageService.reviewsRepo.getData(customKey: cacheKey);
    final bool isConnectedInternet = await NetworkManager.instance.isConnected();

    if (isConnectedInternet) {
      final result = await _reviewsRepo.getReviewsForProduct(productId);

      result.fold(
            (failure) {
          emit(state.copyWith(
            status: ReviewsStatus.error,
            errorMessage: failure.message,
          ));
        },
            (success) {
          emit(state.copyWith(
            status: ReviewsStatus.success,
            reviews: success,
          ));
        },
      );
    } else {
      if (cachedReviews != null && cachedReviews.isNotEmpty) {
        emit(state.copyWith(
          status: ReviewsStatus.success,
          reviews: cachedReviews.map((e) => e.toEntity()).toList(),
        ));
      } else {
        emit(state.copyWith(
          status: ReviewsStatus.error,
          errorMessage: "No internet connection, please check your network.",
        ));
      }
    }
  }

  /// إضافة تقييم جديد
  Future<void> addReview(ReviewEntity review, BuildContext context) async {
    emit(state.copyWith(status: ReviewsStatus.actionInProgress));
    final result = await _reviewsRepo.addReview(review);

    result.fold(
          (failure) {
            emit(state.copyWith(
          status: ReviewsStatus.error,
          errorMessage: failure.message,
        ));
      },
          (_) {
            fetchReviewsForProduct(review.productId);
      },
    );
  }

  /// تعديل تقييم موجود
  Future<void> updateReview(ReviewEntity review, BuildContext context) async {
    emit(state.copyWith(status: ReviewsStatus.actionInProgress));

    final result = await _reviewsRepo.updateReview(review);

    result.fold(
          (failure) {
            emit(state.copyWith(
          status: ReviewsStatus.error,
          errorMessage: failure.message,
        ));
      },
          (_){
    fetchReviewsForProduct(review.productId);
      },
    );
  }

  /// حذف تقييم
  Future<void> deleteReview({
    required String reviewId,
    required String productId,
    required BuildContext context
  }) async {
    FullScreenLoader.popUpCircular(context);
    emit(state.copyWith(status: ReviewsStatus.actionInProgress));
    final result = await _reviewsRepo.deleteReview(
      reviewId: reviewId,
      productId: productId,
    );

    result.fold(
          (failure) {
            FullScreenLoader.stopLoading(context);
            emit(state.copyWith(
          status: ReviewsStatus.error,
          errorMessage: failure.message,
        ));
      },
          (_) {
            FullScreenLoader.stopLoading(context);
            fetchReviewsForProduct(productId);
      },
    );
  }
}