import 'package:fit_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/order/order_cubit.dart';
import '../../../controllers/order/order_state.dart';


class OrderListItems extends StatelessWidget {
  const OrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    context.read<OrderCubit>().fetchUserOrders(context);

    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (state.status == OrderStatusEnum.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == OrderStatusEnum.error) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Something went wrong!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        if (state.orders.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(AppSizes.defaultSpace),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  const Icon(
                    Iconsax.bag_cross,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSizes.spaceBtwItems),
                  Text(
                    'Whoops! No Orders Yet!',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceBtwItems),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Let's fill it"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

         final orders = state.orders;

        return ListView.separated(
          shrinkWrap: true,
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final order = orders[index];

            return RoundedContainer(
              showBorder: true,
              padding: const EdgeInsets.all(AppSizes.md),
              backgroundColor: dark ? AppColors.dark : AppColors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Row(
                    children: [
                       const Icon(Iconsax.ship),
                      const SizedBox(width: AppSizes.spaceBtwItems / 2),

                       Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderStatusText,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: AppColors.primary,
                                fontWeightDelta: 1,
                              ),
                            ),
                            Text(
                              order.formattedOrderDate,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),

                       IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Iconsax.arrow_right_34,
                          size: AppSizes.iconSm,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.spaceBtwItems),

                   Row(
                    children: [
                       Expanded(
                        child: Row(
                          children: [
                             const Icon(Iconsax.tag),
                            const SizedBox(width: AppSizes.spaceBtwItems / 2),

                             Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    order.id,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                       Expanded(
                        child: Row(
                          children: [
                             const Icon(Iconsax.calendar),
                            const SizedBox(width: AppSizes.spaceBtwItems / 2),

                             Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shipping Date',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    order.formattedDeliveryDate,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}