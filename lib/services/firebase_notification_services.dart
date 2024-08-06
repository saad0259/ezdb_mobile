import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../screens/auth_handler.dart';
import '../state/auth_state.dart';
import '../state/dashboard_state.dart';
import '../state/home_state.dart';
import '../utils/prefs.dart';
import '../utils/snippet.dart';

class PushNotification {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final instance = PushNotification();

  initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions();

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ));

    await _notificationsPlugin.initialize(
      initializationSettings,
    );

    SubscribeTopics();
  }

  Future<void> display(RemoteMessage remoteMessage) async {
    try {
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp",
          "pushnotificationappchannel",
          channelDescription: "This is our channel",
          priority: Priority.high,
          importance: Importance.max,
        ),
      );
      final String body = remoteMessage.notification?.body ?? '';
      final String title = remoteMessage.notification?.title ?? '';

      await _notificationsPlugin.show(
        remoteMessage.hashCode,
        title,
        body,
        notificationDetails,
        // payload: remoteMessage.data["routes"],
      );
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  unSubscribeTopics(String id) async {
    if (!kIsWeb) {
      try {
        await FirebaseMessaging.instance.unsubscribeFromTopic("allusers");
      } catch (e) {}
      try {
        await FirebaseMessaging.instance.unsubscribeFromTopic(id);
      } catch (e) {}
    }
  }

  SubscribeTopics() async {
    final String userId = await prefs.userId.load() ?? '';
    log('subscribing to topics: $userId ');
    if (!kIsWeb) {
      await FirebaseMessaging.instance.subscribeToTopic("allusers");
      await FirebaseMessaging.instance.subscribeToTopic(userId);
    }
  }
}

Future<void> handlePushNotifications(BuildContext context) async {
  await PushNotification.instance.initialize();

  FirebaseMessaging.onMessage.listen((message) async {
    log('onMessage: $message');
    await PushNotification.instance.display(message);
    await _logoutNotification(message, context);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    log('onMessage Open: $message');
    await _logoutNotification(message, context);
  });
}

Future<void> _logoutNotification(
    RemoteMessage message, BuildContext context) async {
  if (message.notification?.title?.contains('Logout') ?? false) {
    final AuthState authState = Provider.of<AuthState>(context, listen: false);
    final DashboardState dashboardState =
        Provider.of<DashboardState>(context, listen: false);
    final HomeState homeState = Provider.of<HomeState>(context, listen: false);

    await authState.logout();
    dashboardState.reset();
    homeState.reset();
    popAllAndGoTo(context, AuthHandler());
  }
}
