import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:taskly/components/task_card.dart';
import 'package:taskly/providers/tasks-provider.dart';
import 'package:taskly/theme/colors/app_colors.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed tasks'),
      ),
      body: FutureBuilder(
        future: Provider.of<TasksProvider>(context, listen: true)
            .loadCompletedTasks(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: SpinKitFoldingCube(color: AppColors.contentBrand),
              )
            : Consumer<TasksProvider>(
                child: Center(
                    child:
                        const Text("You haven't completed any task already.")),
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
