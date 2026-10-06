import 'package:fit_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../data/models/address_entity.dart';
import '../../controllers/address_cubit.dart';

class SingleAddress extends StatelessWidget {
  const SingleAddress({
    super.key,
    required this.address,
    required this.onTap,
  });

  final AddressEntity address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
         final isSelected = state.selectedAddress?.id == address.id;
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          child: RoundedContainer(
            showBorder: true,
            padding: const EdgeInsets.all(TSizes.md),
            width: double.infinity,
            backgroundColor: isSelected
                ? TColors.primary.withValues(alpha: 0.5)
                : Colors.transparent,
            borderColor: isSelected
                ? Colors.transparent
                : dark
                ? TColors.darkerGrey
                : TColors.grey,
            margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
            child: Stack(
              children: [
                Positioned(
                  right: 5,
                  top: 0,
                  child: Icon(
                    isSelected ? Iconsax.tick_circle5 : Iconsax.tick_circle,
                    color: isSelected
                        ? TColors.primary
                        : dark
                        ? TColors.darkerGrey
                        : TColors.grey,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: TSizes.sm / 2),
                    Text(
                      address.phoneNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.sm / 2),
                    Text(
                      '${address.street}, ${address.city}, ${address.state}, ${address.country}',
                      softWrap: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}