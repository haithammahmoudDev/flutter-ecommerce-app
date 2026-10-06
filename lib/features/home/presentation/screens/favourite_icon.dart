import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../utils/constants/colors.dart';
import '../controller/favorites_cubit/favorites_cubit.dart';

class TFavouriteIcon extends StatelessWidget {
  const TFavouriteIcon({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final isSelected = context.select<FavoritesCubit, bool>(
      (cubit) => cubit.isFavourite(productId),
    );

    return TCircularIcon(
      icon: isSelected ? Iconsax.heart5 : Iconsax.heart,
      color: isSelected ? TColors.error : null,
      onPressed: () => context.read<FavoritesCubit>().toggleFavoriteProduct(
        productId,
        context,
      ),
    );
  }
}
