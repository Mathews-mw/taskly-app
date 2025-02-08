import 'package:flutter/material.dart';
import 'package:taskly/app_routes.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:taskly/models/custom-notification.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  late FlutterLocalNotificationsPlugin localNotificationPlugin;
  late AndroidNotificationDetails androidNotificationDetails;
  late DarwinNotificationDetails iOsNotificationDetails;

  NotificationsService() {
    localNotificationPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  Future<void> _initializeNotifications() async {
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

    await localNotificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onSelectNotification,
    );
  }

  Future<void> _onSelectNotification(
    NotificationResponse notificationResponse,
  ) async {
    if (notificationResponse.payload != null &&
        notificationResponse.payload!.isNotEmpty) {
      await Navigator.of(AppRoutes.navigatorKey!.currentContext!)
          .pushReplacementNamed(notificationResponse.payload!);
    }
  }

  Future<void> showNotification(CustomNotification notification) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_reminder_channel_id',
        'Task Reminder Notifications',
        channelDescription: 'Task Reminder Notifications',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('id_1', 'Action 1'),
        ],
      ),
      iOS: DarwinNotificationDetails(),
    );

    await localNotificationPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      details,
      payload: notification.payload,
    );
  }

  Future<void> showSchedulingNotification(
    CustomNotification notification,
  ) async {
    if (notification.schedule == null) {
      return;
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'task_reminder_channel_id',
        'Task Reminder Notifications',
        channelDescription: 'Task Reminder Notifications',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('id_1', 'Action 1'),
        ],
      ),
      iOS: DarwinNotificationDetails(),
    );

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(notification.schedule!, tz.local);

    await localNotificationPlugin.cancel(notification.id);

    await localNotificationPlugin
        .zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      scheduledDate,
      details,
      payload: notification.payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    )
        .then((_) {
      print('Notification schedule successfully!');
    }).catchError((error) {
      print('Error scheduling notification: $error');
    });
  }

  Future<void> cancelNotification(int notificationId) async {
    await localNotificationPlugin.cancel(notificationId);
  }

  Future<void> checkForNotifications() async {
    final details =
        await localNotificationPlugin.getNotificationAppLaunchDetails();

    if (details != null &&
        details.didNotificationLaunchApp &&
        details.notificationResponse != null) {
      _onSelectNotification(details.notificationResponse!);
    }
  }
}
