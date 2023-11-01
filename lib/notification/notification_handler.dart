import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../screens/auth_handler.dart';
import '../state/auth_state.dart';
import '../state/dashboard_state.dart';
import '../state/home_state.dart';
import '../utils/snippet.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
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
        ?.requestPermission();

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
  }

  static Future<void> display(RemoteMessage remoteMessage) async {
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
      final String status = remoteMessage.data["status"] ?? '';
      late String message;

      switch (status) {
        case 'canceled':
          message = 'orderCanceledByShop';
          break;
        case 'started':
          message = 'orderStarted';
          break;
        case 'completed':
          message = 'orderCompleted';
          break;
        case 'served':
          message = 'orderServed';
          break;
        default:
          message = body;
          break;
      }

      await _notificationsPlugin.show(
        remoteMessage.hashCode,
        'New from Mega',
        message,
        notificationDetails,
        payload: remoteMessage.data["routes"],
      );
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

void onDidReceiveLocalNotification(BuildContext context, int id, String? title,
    String? body, String? payload) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title ?? 'title'),
      content: Text(body ?? 'body'),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: () async {},
        )
      ],
    ),
  );
}

Future<void> handleNotification(BuildContext context) async {
  await LocalNotification.initialize();

  FirebaseMessaging.onMessage.listen((message) async {
    await LocalNotification.display(message);
    await _logoutNotification(message, context);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    await _logoutNotification(message, context);
  });
  FirebaseMessaging.onBackgroundMessage((message) async {
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
