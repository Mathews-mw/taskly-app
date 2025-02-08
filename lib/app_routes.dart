import 'package:flutter/material.dart';
import 'package:taskly/screens/completed_tasks_screen.dart';
import 'package:taskly/screens/home.dart';
import 'package:taskly/screens/late_tasks_screen.dart';

class AppRoutes {
  static const HOME = '/';
  static const TODAY_TASKS = '/today';
  static const UPCOMING_TASKS = '/upcoming';
  static const LATE_TASKS = '/late';
  static const COMPLETED_TASKS = '/completed';

  static Map<String, Widget Function(BuildContext)> routes =
      <String, WidgetBuilder>{
    AppRoutes.HOME: (ctx) => const HomeScreen(),
    AppRoutes.LATE_TASKS: (ctx) => const LateTasksScreen(),
    AppRoutes.COMPLETED_TASKS: (ctx) => const CompletedTasksScreen(),
  };

  static String initial = AppRoutes.HOME;

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
}
