import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {

  /// TODO: Main Object for manage
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /// TODO: FOR BACKGROUND
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }


  /// TODO: Initialize settings
  void init() async {
    /// Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// Foreground
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      debugPrint('Got a message in the foreground');
      debugPrint('message data: ${remoteMessage.data}');

      if (remoteMessage.notification != null) {
        debugPrint('message is a notification');
        // On Android, foreground notifications are not shown, only when the app
        // is backgrounded.

        /// connecting local notification show
      }
    });
  }


  Future<void> requestMessagingPermission() async {
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
      print("Status: ${settings.authorizationStatus}");
    }

    debugPrint('Users permission status: ${settings.authorizationStatus}');
  }

  Future<String?> generateToken() async {
    final token = await firebaseMessaging.getToken();
    print("Token: $token");
    return token;
  }
}