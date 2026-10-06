import 'package:fit_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/image_strings.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../../../utils/helpers/helper_functions.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = HelperFunctions.isDarkMode(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(TImages.tUserProfileImage),
                ),
                const SizedBox(height: TSizes.spaceBtwItems,),
                Text('Ahmed Mohamed', style: Theme.of(context).textTheme.titleLarge,),
              ],
            ),
            IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems,),
        Row(
          children: [
            RatingBarIndicator(
              rating: 3.5,
              itemSize: 28,
              unratedColor: TColors.grey,
              itemBuilder: (BuildContext context, int index) {
                return Icon(Iconsax.star1, color: TColors.primary,);
              },),
            const SizedBox(height: TSizes.spaceBtwItems,),
            Text('01 Nov, 2025', style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems,),
        ReadMoreText(
          'The user interface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great job!',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: ' show less',
          trimCollapsedText: ' show more',
          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
          lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
        ),
        const SizedBox(height: TSizes.spaceBtwItems,),
        RoundedContainer(
          backgroundColor: dark ? TColors.darkGrey : TColors.grey,
          child: Padding(
              padding: EdgeInsets.all(TSizes.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('hema \'s store', style: Theme.of(context).textTheme.titleLarge,),
                      Text('02 Nov, 2025', style: Theme.of(context).textTheme.bodyLarge,),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems,),
                  ReadMoreText(
                    'The user interface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great job!',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimExpandedText: ' show less',
                    trimCollapsedText: ' show more',
                    moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
                    lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
                  ),
                ],
              ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections,),
      ],
    );
  }
}
