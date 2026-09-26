import 'package:fit_store/common/widgets/appbar/appbar.dart';
import 'package:fit_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:fit_store/data/services/notifications/notification_model.dart';
import 'package:fit_store/routes/routes.dart';
import 'package:fit_store/utils/constants/colors.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/notification_cubit.dart';
 class NotificationDetailScreen extends StatefulWidget {
  const NotificationDetailScreen({super.key});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends State<NotificationDetailScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    final cubit = context.read<NotificationCubit>();

    final notification =
    ModalRoute.of(context)?.settings.arguments as NotificationModel?;

    cubit.setSelectedNotification(
      notification ?? NotificationModel.empty(),
    );

    cubit.setSelectedNotificationId(
      notification?.routeId ?? '',
    );

    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: TAppBar(
        title: const Text('Notification'),
        showSkipButton: false,
        showActions: false,
        showBackArrow: true,
        leadingOnPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return RoundedContainer(
              backgroundColor:
              dark ? TColors.dark : TColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.selectedNotification.type.isNotEmpty)
                    RoundedContainer(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TSizes.sm,
                        vertical: TSizes.sm,
                      ),
                      backgroundColor: TColors.primary,
                      child: Text(
                        state.selectedNotification.type,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .apply(
                          color: Colors.black,
                        ),
                      ),
                    ),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  Text(
                    'Title',
                    style:
                    Theme.of(context).textTheme.labelMedium,
                  ),

                  Text(
                    state.selectedNotification.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .apply(
                      color: dark
                          ? Colors.white
                          : Colors.blue,
                    ),
                  ),

                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  Text(
                    'Message',
                    style:
                    Theme.of(context).textTheme.labelMedium,
                  ),

                  Text(
                    state.selectedNotification.body,
                    style:
                    Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  if (state.selectedNotification.route.isNotEmpty &&
                      state.selectedNotification.route !=
                          TRoutes.notification &&
                      state.selectedNotification.route !=
                          TRoutes.notificationDetails)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            state.selectedNotification.route,
                            arguments: state.selectedNotification,
                          );
                        },
                        icon: const Icon(Iconsax.arrow_right),
                        label: const Text('Redirect'),
                      ),
                    ),

                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}