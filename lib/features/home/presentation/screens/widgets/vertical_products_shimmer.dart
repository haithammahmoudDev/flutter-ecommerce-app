import 'package:fit_store/common/widgets/layouts/grid_layout.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/shimmers/shimmer.dart';

class TVerticalProductShimmer extends StatelessWidget {
  const TVerticalProductShimmer({
    super.key,
    this.itemCount = 4, // عدد البطاقات التخيلية التي ستظهر أثناء التحميل
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return TGridLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) => const SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TShimmerEffect(width: 180, height: 180, radius: TSizes.productImageRadius),
            SizedBox(height: TSizes.spaceBtwItems),
            TShimmerEffect(width: 160, height: 15),
            SizedBox(height: TSizes.spaceBtwItems / 2),
            TShimmerEffect(width: 110, height: 12),
            SizedBox(height: TSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TShimmerEffect(width: 60, height: 20),
                TShimmerEffect(
                  width: TSizes.iconLg * 1.2,
                  height: TSizes.iconLg * 1.2,
                  radius: TSizes.cardRadiusMd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
