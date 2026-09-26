part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  NotificationState({
    this.isLoading = false,
    NotificationModel? selectedNotification,
    this.selectedNotificationId = '',
    this.notifications = const <NotificationModel>[],
  }) : selectedNotification = selectedNotification ?? NotificationModel.empty();

  final bool isLoading;
  final NotificationModel selectedNotification;
  final String selectedNotificationId;
  final List<NotificationModel> notifications;

  NotificationState copyWith({
    bool? isLoading,
    NotificationModel? selectedNotification,
    String? selectedNotificationId,
    List<NotificationModel>? notifications,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      selectedNotification: selectedNotification ?? this.selectedNotification,
      selectedNotificationId: selectedNotificationId ?? this.selectedNotificationId,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [isLoading, selectedNotification, selectedNotificationId, notifications];
}
