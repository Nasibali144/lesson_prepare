import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ServiceForB28 {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// TODO ANDROID 13 and Higher
  Future<bool?> getPermission() async {
    return await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  /// TODO setting:
  Future<void> init() async {
    /// Setting: Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    /// Setting: IOS and Macos
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    /// Setting: Linux
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("This function for foreground");
      },
      // onDidReceiveBackgroundNotificationResponse: (NotificationResponse response) {
      //   print("This function for background");
      // }
    );
  }
  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload)  {
    // display a dialog with the notification details, tap ok to go to another page
    print("On Tapped");
  }

  /// TODO: request
  void requestNotification() async{
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails, iOS: DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(0, 'plain title', 'plain body', notificationDetails, payload: 'item x');
  }
}
