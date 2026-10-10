import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/repository/notifications/notification_repository.dart';
import '../../../../../data/services/notifications/notification_model.dart';


part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState()) {
    listenToNotifications();
  }

  final NotificationRepository repository = NotificationRepository();

  StreamSubscription<List<NotificationModel>>? _notificationsSubscription;

  Future<void> init() async {
    try {
      emit(state.copyWith(isLoading: true));

      if (state.selectedNotification.id.isEmpty &&
          state.selectedNotificationId.isNotEmpty) {
        final notification =
        await repository.fetchSingleItem(state.selectedNotificationId);

        emit(state.copyWith(selectedNotification: notification));
      }

      if (state.selectedNotification.id.isNotEmpty) {
        await markNotificationAsViewed(state.selectedNotification);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      // TLoaders.errorSnackBar(
      //   title: 'Oh Snap',
      //   message: 'Unable to fetch Notification details. Try again.',
      // );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void setSelectedNotification(NotificationModel notification) {
    emit(state.copyWith(selectedNotification: notification));
  }

  void setSelectedNotificationId(String id) {
    emit(state.copyWith(selectedNotificationId: id));
  }

  void listenToNotifications() {
    _notificationsSubscription =
        repository.fetchAllItemsAsStream().listen(
              (notifications) {
            emit(state.copyWith(notifications: notifications));
          },
          onError: (error) {
            // TLoaders.warningSnackBar(
            //   title: 'Error',
            //   message: 'Failed to fetch notifications: $error',
            // );
          },
        );
  }

  Future<void> fetchNotifications() async {
    try {
      final notifications = await repository.fetchAllItems();

      emit(state.copyWith(notifications: notifications));
    } catch (e) {
      // TLoaders.warningSnackBar(
      //   title: 'Error',
      //   message: 'Failed to fetch notifications: $e',
      // );
    }
  }

  Future<void> markNotificationAsViewed(
      NotificationModel notification,
      ) async {
    try {
      final currentUserId =
          FirebaseAuth.instance.currentUser?.uid ?? '';

      if (notification.seenBy.isEmpty ||
          notification.seenBy[currentUserId] == false) {
        await repository.markNotificationAsSeen(
          notification.id,
          currentUserId,
        );

        final updatedNotifications =
        List<NotificationModel>.from(state.notifications);

        final index = updatedNotifications.indexWhere(
              (e) => e.id == notification.id,
        );

        if (index != -1) {
          updatedNotifications[index].seenBy[currentUserId] = true;

          emit(
            state.copyWith(
              notifications: updatedNotifications,
            ),
          );
        }
      }
    } catch (e) {
      // TLoaders.warningSnackBar(
      //   title: 'Error',
      //   message: 'Unable to mark notification as seen: $e',
      // );
    }
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}