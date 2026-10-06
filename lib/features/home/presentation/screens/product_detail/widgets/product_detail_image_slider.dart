import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../domain/entities/product_entity.dart';
import '../../../controller/products_cubit/images_cubit.dart';
import '../../favourite_icon.dart';

class ProductImageSlider extends StatelessWidget {
  const ProductImageSlider({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final heightSafeArea = HelperFunctions.getTopSafeArea(context);
    return TCurvedEdgesWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : Color(0xFFF4F4F4),
        child: Stack(
          children: [
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: TSizes.defaultSpace * 2,
                  left: TSizes.defaultSpace * 1.5,
                  right: TSizes.defaultSpace * 1.5,
                  top: TSizes.defaultSpace * 3,
                ),
                child: BlocBuilder<ImagesCubit, ImagesState>(
                  buildWhen: (previous, current) =>
                  previous.selectedProductImage != current.selectedProductImage,
                  builder: (context, state) {
                    final image = state.selectedProductImage ?? '';

                    if (image.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(color: TColors.primary),
                      );
                    }

                    return GestureDetector(
                      onTap: () => context.read<ImagesCubit>().showEnlargedImage(context, image),
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.contain,
                          progressIndicatorBuilder: (_, __, downloadProgress) =>
                              Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: TColors.primary,
                                ),
                              ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Positioned(
              right: TSizes.defaultSpace,
              left: TSizes.defaultSpace,
              bottom: 30,
              child: SizedBox(
                height: 80,
                child: BlocBuilder<ImagesCubit, ImagesState>(
                  builder: (context, state) {
                    if (state.allProductImages.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.allProductImages.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(width: TSizes.spaceBtwItems),
                      itemBuilder: (_, index) {
                        final image = state.allProductImages[index];
                        final isSelected = state.selectedProductImage == image;

                        return TRoundedImage(
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          isNetworkImage: true,
                          imageUrl: image,
                          padding: const EdgeInsets.all(TSizes.sm),
                          backgroundColor: dark ? TColors.dark : TColors.white,
                          border: Border.all(
                            color: isSelected ? TColors.primary : Colors.transparent,
                            width: 2,
                          ),
                          onPressed: () {
                            context.read<ImagesCubit>().setSelectedProductImage(image);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: heightSafeArea, right: 10
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(icon: Icon(Iconsax.arrow_left_24,),
                  color: dark ? TColors.white : TColors.dark,
                    iconSize: 25,
                    onPressed: () {
                      Navigator.pop(context);
                    },),
                      TFavouriteIcon(productId: product.id),
                    ],
              ),
            )
          ],
        ),
      ),
    );
  }
}