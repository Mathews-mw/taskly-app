import 'package:taskly/models/sub-task.dart';

class Task {
  final int id;
  final String title;
  final String? description;
  final DateTime date;
  final int priority;
  final bool reminder;
  final DateTime? reminderTime;
  bool isCompleted;
  List<SubTask> subTasks;

  Task({
    required this.id,
    required this.title,
    required this.date,
    this.description,
    this.priority = 0,
    this.reminder = false,
    this.reminderTime,
    this.isCompleted = false,
    this.subTasks = const [],
  });

  set title(String title) {
    this.title = title;
  }

  set description(String? description) {
    this.description = description;
  }

  set date(DateTime date) {
    this.date = date;
  }

  set priority(int priority) {
    this.priority = priority;
  }

  set reminder(bool reminder) {
    this.reminder = reminder;
  }

  set reminderTime(DateTime? reminderTime) {
    this.reminderTime = reminderTime;
  }

  set isComplete(bool isComplete) {
    this.isComplete = isComplete;
  }

  @override
  String toString() {
    return 'Task(title: $title, description: $description, date: $date, priority: $priority, reminder: $reminder, reminderTime: $reminderTime, isCompleted: $isCompleted), subTasks: $subTasks';
  }
}
