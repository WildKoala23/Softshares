import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Configure Android to use the app icon for notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS/MacOS: Handle notification received while the app is in the foreground
    void onDidReceiveLocalNotification(
        int? id, String? title, String? body, String? payload) async {
      print('The notification arrived: $title');
    }

    // iOS/MacOS settings
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    // Android and iOS/MacOS settings are embedded together
    final InitializationSettings settings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize the plugin with the configured settings.
    await localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tapped action here
        final String? payload = response.payload;
        if (payload != null) {
          print('Notification payload: $payload');
        }
      },
    );

    // Set up notification channel for Android 8.0+
    await _createNotificationChannel();
  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel', // id
      'Default Channel', // name
      description: 'This is the default notification channel',
      importance: Importance.defaultImportance,
    );

    await localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> showNotification(
      int id, String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel', // id
      'Default Channel', // name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await localNotification.show(id, title, body, platformChannelSpecifics,
        payload: payload);
  }
}
