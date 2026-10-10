import 'package:flutter/cupertino.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../utils/constants/sizes.dart';

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            TShimmerEffect(width: 50, height: 50, radius: 50),
            SizedBox(width: AppSizes.spaceBtwItems),
            Column(
              children: [
                TShimmerEffect(width: 100, height: 15),
                SizedBox(height: AppSizes.spaceBtwItems / 2),
                TShimmerEffect(width: 80, height: 12),
              ],
            ), // Column
          ],
        ), // Row
      ],
    ); // Column
  }
}
