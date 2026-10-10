import 'package:flutter/cupertino.dart';
import '../../../../common/widgets/shimmers/shimmer.dart';
import '../../../../utils/constants/sizes.dart';

class BoxesShimmer extends StatelessWidget {
  const BoxesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: TShimmerEffect(width: 150, height: 110)),
            SizedBox(width: AppSizes.spaceBtwItems),
            Expanded(child: TShimmerEffect(width: 150, height: 110)),
            SizedBox(width: AppSizes.spaceBtwItems),
            Expanded(child: TShimmerEffect(width: 150, height: 110)),
          ],
        ) // Row
      ],
    ); // Column
  }
}
