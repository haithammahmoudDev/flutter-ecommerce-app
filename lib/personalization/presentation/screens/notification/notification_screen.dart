// Original file: lib/personalization/screens/notifications/notification_screen.dart
// Converted: NotificationController.instance -> context.read<NotificationCubit>(), Obx -> BlocBuilder
import 'package:fit_store/common/widgets/appbar/appbar.dart';
import 'package:fit_store/routes/routes.dart';
import 'package:fit_store/utils/constants/sizes.dart';
import 'package:fit_store/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart'; // kept only for Get.toNamed() navigation - out of scope
import 'package:iconsax/iconsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../controllers/notification_cubit.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: const TAppBar(title: Text('Notifications'), showSkipButton: false, showActions: false, showBackArrow: true),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state.notifications.isEmpty) {
              return const Center(child: Text('No notifications available.'));
            }

            return ListView.separated(
              itemCount: state.notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return RoundedContainer(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                  backgroundColor: notification.seenBy[(FirebaseAuth.instance.currentUser?.uid ?? '')] == true
                      ? Colors.grey.withValues(alpha: 0.15)
                      : Colors.blue.withValues(alpha: 0.15),
                  child: ListTile(
                    leading: Icon(Iconsax.notification_bing,
                        color: notification.seenBy[(FirebaseAuth.instance.currentUser?.uid ?? '')] == true
                            ? Colors.grey
                            : Colors.blue),
                    title: Text(
                      notification.title,
                      style: Theme.of(context).textTheme.titleMedium!.apply(color: dark ? Colors.white : Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                        Text(notification.formattedDate,
                            style: Theme.of(context).textTheme.labelMedium!.apply(color: Colors.grey)),
                      ],
                    ),
                    trailing: notification.seenBy[(FirebaseAuth.instance.currentUser?.uid ?? '')] == true
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Icon(CupertinoIcons.circle_filled, color: Colors.blue),
                    onTap: () => Get.toNamed(TRoutes.notificationDetails, arguments: notification),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}