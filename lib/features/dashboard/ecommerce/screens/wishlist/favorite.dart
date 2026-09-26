// import 'package:fit_store/common/widgets/appbar/appbar.dart';
// import 'package:fit_store/common/widgets/icons/t_circular_icon.dart';
// import 'package:fit_store/common/widgets/layouts/grid_layout.dart';
// import 'package:fit_store/features/products/controllers/product_cubit.dart';
// import 'package:fit_store/features/products/screens/product_cards/product_card_vertical.dart';
// import 'package:fit_store/utils/constants/sizes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iconsax/iconsax.dart';
//
//
// class FavoriteScreen extends StatelessWidget {
//   const FavoriteScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: TAppBar(
//         showActions: true,
//         showSkipButton: false,
//         title: Text(
//           'Wishlist',
//           style: Theme.of(context).textTheme.headlineMedium,
//         ),
//         actions: [
//           TCircularIcon(
//             icon: Iconsax.add,
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(TSizes.defaultSpace),
//         child: BlocBuilder<ProductCubit, ProductState>(
//           builder: (context, state) {
//             final products = state.products
//                 .where((product) => state.favorites[product.id] ?? false)
//                 .toList();
//
//             if (products.isEmpty) {
//               return const Center(
//                 child: Text('No favourite products'),
//               );
//             }
//
//             return TGridLayout(
//               itemCount: products.length,
//               itemBuilder: (_, index) {
//                 return TProductCardVertical(
//                   product: products[index],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }