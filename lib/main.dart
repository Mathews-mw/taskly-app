import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:taskly/app_routes.dart';
import 'package:taskly/theme/theme.dart';
import 'package:taskly/providers/tasks-provider.dart';
import 'package:taskly/handlers/permissions-handler.dart';
import 'package:taskly/providers/sub-tasks-provider.dart';
import 'package:taskly/services/notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PermissionsHandler.requestNotificationPermission();
  // await PermissionsHandler.requestExactAlarmPermission();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return MultiProvider(
      providers: [
        Provider<NotificationsService>(create: (_) => NotificationsService()),
        ChangeNotifierProvider(create: (_) => SubTasksProvider()),
        ChangeNotifierProvider(
          create: (ctx) => TasksProvider(
            notificationsService:
                Provider.of<NotificationsService>(ctx, listen: false),
            subTasksProvider: Provider.of<SubTasksProvider>(ctx, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Taskly',
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? darkModeTheme : lightModeTheme,
        themeMode: ThemeMode.system,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
        navigatorKey: AppRoutes.navigatorKey,
      ),
    );
  }
}
