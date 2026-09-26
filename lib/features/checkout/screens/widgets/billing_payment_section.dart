import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../home/presentation/controller/checkout/checkout_cubit.dart';
import '../../../home/presentation/controller/checkout/checkout_state.dart';
import '../../controllers/checkout_cubit.dart';
import '../../controllers/checkout_state.dart';


class BillingPaymentSection extends StatelessWidget {
  const BillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        return Column(
          children: [
            SectionHeading(
              title: 'Payment Method',
              buttonTitle: 'Change',
              onPressed: () => context.read<CheckoutCubit>().showPaymentMethodsModal(context),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Row(
              children: [
                RoundedContainer(
                  width: 60,
                  height: 35,
                  backgroundColor: dark ? TColors.white : TColors.white,
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: Image(
                    image: AssetImage(state.selectedPaymentMethod.image),
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: TSizes.spaceBtwItems / 2),
                Text(
                  state.selectedPaymentMethod.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}