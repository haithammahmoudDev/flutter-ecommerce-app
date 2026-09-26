import 'package:fit_store/utils/helpers/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import '../../../../../common/di/injection_container.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../domain/entities/product_entity.dart';
import '../../controller/products_cubit/images_cubit.dart';
import '../../controller/products_cubit/variation_cubit.dart';
import '../product_reviews/product_reviews.dart';
import 'widgets/bottom_add_to_cart_widget.dart';
import 'widgets/product_attributes.dart';
import 'widgets/product_detail_image_slider.dart';
import 'widgets/product_meta_data.dart';
import 'widgets/rating_share_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  static const routeName = TRoutes.productDetails;
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final bool isDark = THelperFunctions.isDarkMode(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ImagesCubit>()..getAllProductImages(product),
        ),
        BlocProvider(
          create: (context) => sl<VariationCubit>(),
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: BottomAddToCart(product: product.toModel()),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImageSlider(product: product),
              Padding(
                padding: const EdgeInsets.only(
                  right: TSizes.defaultSpace,
                  left: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     const RatingAndShare(),

                    ProductMetaData(product: product),

                    const SizedBox(height: TSizes.spaceBtwSections / 2),

                    if (product.productType == 'variable')
                      ProductAttributes(product: product),
                    if (product.productType == 'variable')
                      const SizedBox(height: TSizes.spaceBtwSections / 2),

                     SizedBox(
                      width: TDeviceUtils.getScreenWidth(context),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            TRoutes.checkoutScreen,
                            arguments: product,
                          );
                        },
                        child: const Text('Checkout'),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections / 2),

                     const SectionHeading(
                      title: 'Description',
                      showActionButton: false,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                     ReadMoreText(
                      product.description ??
                          'No description available for this product.',
                      trimLines: 2,
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' Show more',
                      trimExpandedText: ' Less',
                      moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                      lessStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),

                     GestureDetector(
                       onTap: (){
                         Navigator.pushNamed(
                           context,
                           ProductReviewsScreen.routeName,
                           arguments: product,
                         );
                       },
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SectionHeading(
                            title: 'Reviews (199)',
                            showActionButton: false,
                          ),
                          Icon(
                              Iconsax.arrow_right_3,
                              size: 18,
                            color: isDark ? TColors.white : TColors.dark,
                          ),
                        ],
                                           ),
                     ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}