import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskly/app_routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationsService {
  static final NotificationsService _instance =
      NotificationsService._internal();

  factory NotificationsService() {
    return _instance;
  }

  NotificationsService._internal();

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initAndroidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initIOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initAndroidSettings,
      iOS: initIOSSettings,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print('Notification ID: ${notificationResponse.id}');
        print('Notification Action ID: ${notificationResponse.actionId}');
        print('Notification Payload: ${notificationResponse.payload}');
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    await _setupTimeZone();

    _isInitialized = true;
  }

  _onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.of(AppRoutes.navigatorKey!.currentContext!).pushNamed(payload);
    }
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'task_reminder_channel_id',
        'Task Reminder Notifications',
        channelDescription: 'Task Reminder Notifications',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('id_1', 'Action 1'),
          AndroidNotificationAction('id_2', 'Action 2'),
          AndroidNotificationAction('id_3', 'Action 3'),
        ],
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> _setupTimeZone() async {
    tz.initializeTimeZones();

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    print('Notification Background ID: ${notificationResponse.id}');
    print(
        'Notification Background Action ID: ${notificationResponse.actionId}');
    print('Notification Background Payload: ${notificationResponse.payload}');
  }

  Future<void> showNotification({int id = 0, String? title, String? body}) {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
      payload: 'Notification payload test',
    );
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> checkForNotifications() async {
    final details = await notificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.notificationResponse?.payload);
    }
  }
}
