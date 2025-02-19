import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:taskly/models/task.dart';
import 'package:taskly/providers/sub-tasks-provider.dart';
import 'package:taskly/theme/colors/app_colors.dart';
import 'package:taskly/providers/tasks-provider.dart';
import 'package:taskly/components/edit-task-form.dart';
import 'package:taskly/components/create-sub-task-form.dart';

class TaskDetails extends StatelessWidget {
  final Task task;
  final Color priorityColor;
  final ScrollController scrollController; // scrollable controller

  const TaskDetails({
    super.key,
    required this.task,
    required this.priorityColor,
    required this.scrollController,
  });

  _handleAddSubTask(BuildContext ctx) {
    return showModalBottomSheet(
      context: ctx,
      builder: (BuildContext context) {
        return CreateSubTaskForm(task: task);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subTasksProvider = Provider.of<SubTasksProvider>(context);
    final subTasks = subTasksProvider.getSubTasksByTaskId(task.id);

    return SingleChildScrollView(
      controller: scrollController, // Conectando o controlador
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).hintColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                height: 4,
                width: 80,
                margin: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TaskMenuOptions(task: task),
              ],
            ),
            if (task.description != null)
              Text(
                task.description ?? '',
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (task.reminder && task.reminderTime != null)
                  Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedAlarmClock,
                        size: 18,
                        color: AppColors.contentBrand,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        DateFormat('Hm').format(task.reminderTime!),
                        style: TextStyle(
                          color: AppColors.contentBrand,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                Row(
                  children: [
                    Icon(
                      HugeIcons.strokeRoundedFlag03,
                      size: 18,
                      color: priorityColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      task.priority == 0
                          ? 'Sem prioridade'
                          : 'Prioridade ${task.priority}',
                      style: TextStyle(color: priorityColor),
                    ),
                  ],
                )
              ],
            ),
            const Divider(),
            Text("Sub-tasks", style: Theme.of(context).textTheme.titleMedium),
            subTasks.isEmpty
                ? const Center(child: Text("You don't have any sub-tasks"))
                : ListView.builder(
                    shrinkWrap:
                        true, // Permite que a ListView cresça conforme os itens
                    physics:
                        NeverScrollableScrollPhysics(), // Impede rolagem interna, deixando o modal rolar
                    itemCount: subTasks.length,
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        leading: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.circle_outlined),
                        ),
                        title: Text(
                          subTasks[index].title,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.close,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
            Center(
              child: TextButton.icon(
                onPressed: () => _handleAddSubTask(context),
                label: const Text('Add Sub-task'),
                icon: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskMenuOptions extends StatefulWidget {
  final Task task;

  const TaskMenuOptions({super.key, required this.task});

  @override
  State<TaskMenuOptions> createState() => _TaskMenuOptionsState();
}

class _TaskMenuOptionsState extends State<TaskMenuOptions> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TasksProvider>(context, listen: true);

    return MenuAnchor(
      menuChildren: <Widget>[
        if (!widget.task.isCompleted)
          MenuItemButton(
            child: ListTile(
              leading: Icon(
                HugeIcons.strokeRoundedCheckmarkSquare04,
                size: 20,
              ),
              title: Text('Complete task'),
            ),
            onPressed: () async {
              widget.task.isCompleted = true;
              await taskProvider.updateTask(widget.task);

              if (mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Task Done!'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () async {
                      widget.task.isCompleted = false;
                      await taskProvider.updateTask(widget.task);
                    },
                  ),
                ));

                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
          ),
        if (widget.task.isCompleted)
          MenuItemButton(
            child: ListTile(
              leading: Icon(
                HugeIcons.strokeRoundedRepeat,
                size: 20,
              ),
              title: Text('Repeat task'),
            ),
            onPressed: () async {
              widget.task.isCompleted = false;
              await taskProvider.updateTask(widget.task);

              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        if (!widget.task.isCompleted)
          MenuItemButton(
            child: ListTile(
              leading: Icon(
                HugeIcons.strokeRoundedPencilEdit02,
                size: 20,
              ),
              title: Text('Edit task'),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) {
                  return EditTaskForm(task: widget.task);
                },
              );
            },
          ),
        MenuItemButton(
          child: ListTile(
            leading: Icon(
              HugeIcons.strokeRoundedDelete02,
              color: AppColors.error,
              size: 20,
            ),
            title: Text(
              'Delete task',
              style: TextStyle(
                color: AppColors.error,
              ),
            ),
          ),
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(
                  'Are you sure?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                content: const Text(
                    "Are you really sure you want to delete this task? This action can't be undone."),
                actions: [
                  TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: AppColors.error),
                    ),
                    onPressed: () async {
                      await taskProvider.deleteTask(widget.task);
                      if (mounted) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }
                    },
                  ),
                ],
              ),
            );
          },
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
    );
  }
}
