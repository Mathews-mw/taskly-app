import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/screens/today_tasks_screen.dart';
import 'package:taskly/screens/upcoming.tasks_screen.dart';
import 'package:taskly/services/notifications_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // checkNotification();
  }

  checkNotification() async {
    await Provider.of<NotificationsService>(context, listen: false)
        .checkForNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: <Widget>[
          TodayTasksScreen(),
          UpcomingTasksScreen(),
        ][currentPageIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        // backgroundColor: AppColors.backgroundBrand,
        onDestinationSelected: (pageIndex) {
          setState(() {
            currentPageIndex = pageIndex;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Today',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Upcoming',
          )
        ],
      ),
    );
  }
}
