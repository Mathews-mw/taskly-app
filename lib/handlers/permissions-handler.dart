import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionsHandler {
  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  static Future<void> requestExactAlarmPermission() async {
    print(
        'is schedule exact alarm denied: ${await Permission.scheduleExactAlarm.isDenied}');
    if (Platform.isAndroid) {
      // Verifica se está rodando no Android 12+ (API 31+)
      if (await _isExactAlarmPermissionNeeded()) {
        // Abre a tela de permissões do usuário
        if (await Permission.scheduleExactAlarm.isDenied) {
          await openAppSettings();
        }
      }
    }
  }

  static Future<bool> _isExactAlarmPermissionNeeded() async {
    if (Platform.isAndroid) {
      final int sdkInt = int.parse(await getAndroidSdkVersion());
      return sdkInt >= 31;
    }
    return false;
  }

  static Future<String> getAndroidSdkVersion() async {
    return (await Process.run('getprop', ['ro.build.version.sdk']))
        .stdout
        .trim();
  }
}
