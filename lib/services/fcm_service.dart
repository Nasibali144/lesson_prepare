import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:lesson_prepare/services/service_two.dart';

class FCMService {
  /// TODO: Main Object for manage
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final local = ServiceForB28();

  /// TODO: FOR BACKGROUND
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (kDebugMode) {
      print("Handling a background message: ${message.messageId}");
    }
  }

  /// TODO: Initialize settings
  Future<void> init() async {
    /// Foreground - Local Notification Integration For Android
    await local.init();

    /// Foreground - Settings IOS
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    /// Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// Foreground
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      print("message: ${message.data}");
      if (notification != null && android != null) {
        local.requestNotification(message.data['title'], message.data['body']);
      }
    });
  }

  Future<void> requestMessagingPermission() async {
    await local.getPermission();
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("Status: ${settings.authorizationStatus}");
      }
    }

    debugPrint('Users permission status: ${settings.authorizationStatus}');
  }

  Future<String?> generateToken() async {
    final token = await firebaseMessaging.getToken();
    if (kDebugMode) {
      print("Token: $token");
    }
    return token;
  }

  void sendMessageForOne() async {
    firebaseMessaging.sendMessage(
        to: await generateToken(),
        data: {"title": "Hello", "body": "Hello FCM"});
  }
}
