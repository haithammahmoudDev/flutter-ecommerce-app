import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fit_store/data/services/notifications/lib/core/navigation/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

 import '../../../utils/popups/loaders.dart';
import 'notification_model.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class TNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final List<NotificationModel> notifications = [];

  Future<void> initializeNotifications() async {
    await requestPermission();
    _initializeLocalNotifications();
    _setupFirebaseListeners();
  }

  /// -- Request Permission on App Launch
  Future<void> requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      // TLoaders.warningSnackBar(
      //   title: 'No Permission',
      //   message: 'Notification permissions denied.',
      // );
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      // TLoaders.warningSnackBar(
      //   title: 'No Permission',
      //   message: 'Notification permissions not determined.',
      // );
    } else {
      if (kDebugMode) {
        print('Notification permissions granted.');
      }
    }
  }

  /// -- Get User's FCM Token
  static Future<String> getToken() async {
    await Future.delayed(const Duration(seconds: 5));

    final token = await FirebaseMessaging.instance.getToken();

    if (kDebugMode) {
      print('FCM Token: $token');
    }

    return token ?? '';
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );
  }

  void _setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpenedApp);

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  }

  void _onMessageReceived(RemoteMessage message) {
    _showLocalNotification(message);
  }

  void _onNotificationOpenedApp(RemoteMessage message) {
    _handleNotificationRedirect(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final String? route = message.data['route'];
    final String? parameter = message.data['id'];

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _localNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: '$route?id=$parameter',
    );
  }

  void addNotification(
      RemoteMessage message, {
        String? route,
        String? routeId,
      }) {
    final notification = NotificationModel(
      id: message.messageId ?? '',
      title: message.notification?.title ?? 'No Title',
      body: message.notification?.body ?? 'No Body',
      route: route ?? '',
      routeId: routeId ?? '',
      createdAt: DateTime.now(),
      seenBy: {},
      isBroadcast: false,
      type: '',
      recipientIds: [],
      senderId: '',
    );

    notifications.add(notification);
  }

  Future<void> _onSelectNotification(
      NotificationResponse notificationResponse,
      ) async {
    if (notificationResponse.payload != null &&
        notificationResponse.payload!.isNotEmpty) {
      NavigationService.pushNamed(
        notificationResponse.payload!,
      );
    }
  }

  Future<void> _onDidReceiveLocalNotification(
      int id,
      String? title,
      String? body,
      String? payload,
      ) async {
    if (payload != null) {
      NavigationService.pushNamed(payload);
    }
  }

  Future<void> handleInitialMessage() async {
    final initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationRedirect(initialMessage);
    }
  }

  void _handleNotificationRedirect(RemoteMessage message) {
    final String? route = message.data['route'];
    final String? parameter = message.data['id'];

    if (route != null) {
      NavigationService.pushNamed(
        route,
        arguments: {
          'id': parameter ?? '',
        },
      );
    }
  }
}