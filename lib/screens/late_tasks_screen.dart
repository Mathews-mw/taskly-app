import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:taskly/components/task_card.dart';
import 'package:taskly/providers/tasks-provider.dart';
import 'package:taskly/theme/colors/app_colors.dart';

class LateTasksScreen extends StatefulWidget {
  const LateTasksScreen({super.key});

  @override
  State<LateTasksScreen> createState() => _LateTasksScreenState();
}

class _LateTasksScreenState extends State<LateTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Late tasks'),
      ),
      body: FutureBuilder(
        future:
            Provider.of<TasksProvider>(context, listen: false).loadPastTasks(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: SpinKitFoldingCube(color: AppColors.contentBrand),
              )
            : Consumer<TasksProvider>(
                child: Center(
                  child: const Text(
                      'Everything is up to date. You have no overdue tasks.'),
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
    );
  }
}
