import 'package:carousel_slider/carousel_slider.dart';
import 'package:fit_store/features/home/domain/entities/banners_entity.dart';
import 'package:fit_store/features/home/presentation/controller/promo_slider_cubit/promo_slider_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/constants/enums.dart';
import '../../../../../common/di/injection_container.dart';

class TPromoSlider extends StatelessWidget {
  const TPromoSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PromoSliderCubit>()..fetchBanners(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<PromoSliderCubit, PromoSliderState>(
            builder: (context, state) {
              switch (state.status) {
                case PromoSliderEnum.loading:
                  return _buildLoadingShimmer();

                case PromoSliderEnum.error:
                  return _buildError(context, state.errorMessage);

                case PromoSliderEnum.loaded:
                  final banners = state.bannerEntityList;
                  if (banners.isEmpty) {
                    return _buildError(context, 'No banners available');
                  }
                  return _buildLoadedSlider(context, banners, state.currentIndex);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: TColors.grey,
      highlightColor: TColors.grey.withOpacity(0.5),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(TSizes.md),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.red),
            const SizedBox(height: TSizes.sm),
            Text(
              message ?? 'Something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: TSizes.sm),
            TextButton(
              onPressed: () => context.read<PromoSliderCubit>().fetchBanners(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedSlider(BuildContext context, List<BannerEntity> banners, int currentIndex) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            onPageChanged: (index, _) {
              context.read<PromoSliderCubit>().onPageChanged(index);
            },
          ),
          items: banners
              .map((banner) => TRoundedImage(
            imageUrl: banner.imageUrl,
            isNetworkImage: true,
            onPressed: () {
              // منطق التوجيه بناءً على الـ targetType القادم من الـ Admin Panel
              switch (banner.targetType) {
                case BannerTargetType.none:
                  break;
                case BannerTargetType.store:
                // Navigator.pushNamed(context, '/store-screen');
                  break;
                case BannerTargetType.product:
                  if (banner.targetId.isNotEmpty) {
                    // Navigator.pushNamed(context, '/product-details',
                    // arguments: banner.targetId);
                  }
                  break;
                case BannerTargetType.category:
                  if (banner.targetId.isNotEmpty) {
                    // Navigator.pushNamed(context, '/sub-categories',
                    // arguments: banner.targetId);
                  }
                  break;
                case BannerTargetType.external:
                  if (banner.targetId.isNotEmpty) {
                    // فتح رابط خارجي URL
                  }
                  break;
              }
            },
          ))
              .toList(),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < banners.length; i++)
                BlocSelector<PromoSliderCubit, PromoSliderState, int>(
                  selector: (state) => state.currentIndex,
                  builder: (context, currentIndex) {
                    return TCircularContainer(
                      width: 20,
                      height: 4,
                      margin: const EdgeInsets.only(right: 10),
                      backgroundColor: currentIndex == i
                          ? TColors.dashboardAppbarBackground
                          : TColors.grey,
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