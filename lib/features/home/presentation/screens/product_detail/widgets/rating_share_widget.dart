import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../domain/entities/product_entity.dart';

class RatingAndShare extends StatelessWidget {
  const RatingAndShare({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Iconsax.star5, color: Colors.amber, size: 24),
            const SizedBox(width: TSizes.spaceBtwItems / 2),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '5.0 ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const TextSpan(text: '(199)'),
                ],
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            final link = 'https://fit-store-azure.vercel.app/product/${product.id}';            SharePlus.instance.share(
              ShareParams(
                text: 'Check out ${product.title} on Fit Store!\n\n$link',
                subject: product.title,
              ),
            );
          },
          icon: const Icon(Icons.share, size: TSizes.iconMd),
        ),
      ],
    );
  }
}