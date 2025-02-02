import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:taskly/components/task-details.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/theme/colors/app_colors.dart';

class TaskCard extends StatelessWidget {
  Task task;

  TaskCard({super.key, required this.task});

  Color priorityBgColor(int priority) {
    late Color result;

    switch (task.priority) {
      case 0:
        result = AppColors.borderSecondary;
        break;
      case 1:
        result = AppColors.accentBlue;
        break;
      case 2:
        result = AppColors.accentOrange;
        break;
      case 3:
        result = AppColors.error;
        break;
      default:
        result = AppColors.borderSecondary;
    }

    return result;
  }

  _taskDetailsBottomSheet(BuildContext ctx) {
    return showModalBottomSheet(
      context: ctx,
      builder: (BuildContext context) {
        return TaskDetails(
          task: task,
          priorityColor: priorityBgColor(task.priority),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Container(
              color: priorityBgColor(task.priority),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    HugeIcons.strokeRoundedFlag03,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    task.priority == 0
                        ? 'Sem prioridade'
                        : 'Prioridade ${task.priority}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Expanded(
                    child: const SizedBox(
                      width: 10,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                    onPressed: () => _taskDetailsBottomSheet(context),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    task.isCompleted
                        ? Icon(
                            HugeIcons.strokeRoundedCheckmarkCircle02,
                            size: 22,
                            color: AppColors.success,
                          )
                        : Icon(
                            HugeIcons.strokeRoundedCircle,
                            size: 22,
                            color: AppColors.borderSecondary,
                          ),
                    const SizedBox(width: 8),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationThickness: 1.5,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
                if (task.description != null)
                  Text(
                    task.description ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 10),
                Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    task.reminder && task.reminderTime != null
                        ? Row(
                            children: [
                              Icon(
                                HugeIcons.strokeRoundedAlarmClock,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                DateFormat('Hm').format(task.reminderTime!),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : const SizedBox(width: 10),
                    Text(
                      DateFormat.yMMMMd().format(task.date),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
