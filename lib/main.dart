import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/providers/tasks-provider.dart';
import 'package:taskly/screens/completed_tasks_screen.dart';
import 'package:taskly/screens/home.dart';
import 'package:taskly/screens/late_tasks_screen.dart';
import 'package:taskly/theme/theme.dart';
import 'package:taskly/utils/app_routes.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle().copyWith(
  //     statusBarColor: AppColors.backgroundBrand,
  //     systemNavigationBarColor: AppColors.backgroundBrand,
  //   ),
  // );

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
        ChangeNotifierProvider(create: (_) => TasksProvider()),
      ],
      child: MaterialApp(
        title: 'Taskly',
        debugShowCheckedModeBanner: false,
        theme: isDarkMode ? darkModeTheme : lightModeTheme,
        themeMode: ThemeMode.system,
        // home: HomeScreen(),
        routes: {
          AppRoutes.HOME: (ctx) => const HomeScreen(),
          AppRoutes.LATE_TASKS: (ctx) => const LateTasksScreen(),
          AppRoutes.COMPLETED_TASKS: (ctx) => const CompletedTasksScreen(),
        },
      ),
    );
  }
}
