import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:taskly/app_routes.dart';
import 'package:taskly/components/task_card.dart';
import 'package:taskly/theme/colors/app_colors.dart';
import 'package:taskly/providers/tasks-provider.dart';
import 'package:taskly/models/custom-notification.dart';
import 'package:taskly/components/create-task-form.dart';
import 'package:taskly/services/notifications_service.dart';

class TodayTasksScreen extends StatefulWidget {
  const TodayTasksScreen({super.key});

  @override
  State<TodayTasksScreen> createState() => _TodayTasksScreenState();
}

class _TodayTasksScreenState extends State<TodayTasksScreen> {
  Future<void> _refreshTasks(BuildContext context) {
    return Provider.of<TasksProvider>(context, listen: false).loadTodayTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today tasks'),
        actions: [
          MenuAnchor(
            menuChildren: <Widget>[
              MenuItemButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.LATE_TASKS);
                },
                child: ListTile(
                  leading: Icon(HugeIcons.strokeRoundedInbox),
                  title: Text('Late tasks'),
                ),
              ),
              MenuItemButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.COMPLETED_TASKS);
                },
                child: ListTile(
                  leading: Icon(HugeIcons.strokeRoundedDocumentValidation),
                  title: Text('Completed tasks'),
                ),
              )
            ],
            builder: (_, MenuController controller, Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_vert),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshTasks(context),
        child: FutureBuilder(
          future: Provider.of<TasksProvider>(context).loadTodayTasks(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: SpinKitFoldingCube(color: AppColors.contentBrand),
                )
              : Consumer<TasksProvider>(
                  child: Center(
                    child: const Text("You don't have any tasks today yet."),
                  ),
                  builder: (ctx, tasksProvider, child) {
                    if (tasksProvider.itemsAmount == 0) {
                      return child!;
                    }

                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: ListView.separated(
                        itemCount: tasksProvider.itemsAmount,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          return TaskCard(task: tasksProvider.items[i]);
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: CreateTaskForm(),
    );
  }
}
