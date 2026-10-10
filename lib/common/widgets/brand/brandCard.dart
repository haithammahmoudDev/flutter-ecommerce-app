import 'package:fit_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fit_store/common/widgets/images/t_circular_image.dart';
import 'package:fit_store/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:fit_store/features/store/domain/entities/brand_entity.dart';
import 'package:fit_store/utils/constants/enums.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Brandcard extends StatelessWidget {
  const Brandcard({super.key, this.onTap, required this.showBorder, required this.brand});
  final VoidCallback? onTap;
  final bool showBorder;
  final BrandEntity brand;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: RoundedContainer(
        padding:const EdgeInsets.all(AppSizes.sm),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          children: [
            CircularImage(
              image: brand.image,
              isNetworkImage: true,
              backgroundColor: Colors.transparent,
             ),
            const  SizedBox(width: AppSizes.spaceBtwItems / 2,),
            Expanded(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrandTitleWithVerifiedIcon(title: brand.name, brandTextSize: TextSizes.large,),
                Text('${brand.productsCount} Products',
                  style: Theme.of(context).textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
