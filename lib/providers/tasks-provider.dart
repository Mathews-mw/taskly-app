import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'package:taskly/app_routes.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/data/app_database.dart';
import 'package:taskly/models/custom-notification.dart';
import 'package:taskly/utils/format_date_to_sqlite.dart';
import 'package:taskly/providers/sub-tasks-provider.dart';
import 'package:taskly/services/notifications_service.dart';

class TasksProvider with ChangeNotifier {
  final NotificationsService notificationsService;
  final SubTasksProvider subTasksProvider;

  TasksProvider(
      {required this.notificationsService, required this.subTasksProvider});

  List<Task> _items = [];

  List<Task> get items {
    return [..._items];
  }

  int get itemsAmount {
    return _items.length;
  }

  List<Task> _mapperDatabaseToObject(List<Map<String, dynamic>> data) {
    return _items = data.map((item) {
      final subTasks = subTasksProvider.getSubTasksByTaskId(item['id']);

      final task = Task(
        id: item['id'],
        title: item['title'],
        description: item['description'],
        priority: item['priority'],
        date: DateTime.parse(item['date']),
        reminder: item['reminder'] == 1 ? true : false,
        reminderTime: item['reminderTime'] != ''
            ? DateTime.parse(item['reminderTime'])
            : null,
        isCompleted: item['isCompleted'] == 1 ? true : false,
        subTasks: subTasks,
      );

      return task;
    }).toList();
  }

  Future<void> loadTasks() async {
    final db = await AppDatabase().database;

    final List<Map<String, dynamic>> dataList =
        await db.query(DbTables.tasks.value);

    // await Future.delayed(Duration(seconds: 3));

    _items = _mapperDatabaseToObject(dataList);
  }

  Future<List<Task>> loadTodayTasks() async {
    List<Task> todayTasks = [];

    final db = await AppDatabase().database;

    final List<Map<String, dynamic>> dataList = await db
        .query(DbTables.tasks.value, where: "date = date('now', 'localtime')");

    todayTasks = _mapperDatabaseToObject(dataList);

    return todayTasks;
  }

  Future<List<Task>> loadPastTasks() async {
    List<Task> pastTasks = [];

    final db = await AppDatabase().database;

    final List<Map<String, dynamic>> dataList = await db
        .query(DbTables.tasks.value, where: "date < date('now', 'localtime')");

    pastTasks = _mapperDatabaseToObject(dataList);

    return pastTasks;
  }

  Future<List<Task>> loadFutureTasks() async {
    List<Task> futureTasks = [];

    final db = await AppDatabase().database;

    final List<Map<String, dynamic>> dataList = await db
        .query(DbTables.tasks.value, where: "date > date('now', 'localtime')");

    futureTasks = _mapperDatabaseToObject(dataList);

    return futureTasks;
  }

  Future<List<Task>> loadCompletedTasks() async {
    List<Task> pastTasks = [];

    final db = await AppDatabase().database;

    final List<Map<String, dynamic>> dataList =
        await db.query(DbTables.tasks.value, where: "isCompleted = 1");

    pastTasks = _mapperDatabaseToObject(dataList);

    return pastTasks;
  }

  Future<void> saveTask({required Map<String, Object> data}) async {
    bool hasId = data['id'] != null;

    final taskFormDate = data['date'] as DateTime;
    final taskFormTime = data['reminderTime'] as TimeOfDay?;
    DateTime? reminderTime;

    if (taskFormTime != null) {
      reminderTime = DateTime(
        taskFormDate.year,
        taskFormDate.month,
        taskFormDate.day,
        taskFormTime.hour,
        taskFormTime.minute,
      );
    }

    final task = Task(
      id: hasId
          ? data['id'] as int
          : DateTime.now().microsecondsSinceEpoch.remainder(10000000),
      title: data['title'] as String,
      description: data['description'] as String?,
      priority: data['priority'] as int,
      date: DateTime(
        taskFormDate.year,
        taskFormDate.month,
        taskFormDate.day,
      ),
      reminder: reminderTime != null ? true : false,
      reminderTime: reminderTime,
    );

    if (hasId) {
      return await updateTask(task);
    } else {
      return await createTask(task);
    }
  }

  Future<void> createTask(Task task) async {
    _items.add(task);

    final db = await AppDatabase().database;

    final taskData = {
      'id': task.id,
      'title': task.title,
      'description': task.description ?? '',
      'date': FormatDateToSQLite.format(task.date),
      'priority': task.priority,
      'reminder': task.reminder ? 1 : 0,
      'reminderTime':
          task.reminderTime != null ? task.reminderTime!.toIso8601String() : '',
      'isCompleted': 0,
    };

    final result = await db.insert(
      DbTables.tasks.value,
      taskData,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    if (task.reminder && task.reminderTime != null) {
      await notificationsService.showSchedulingNotification(CustomNotification(
        id: task.id,
        title: task.title,
        body:
            'You have a task due now. Click on the notification for more details.',
        payload: AppRoutes.HOME,
        schedule: task.reminderTime,
      ));
    }

    print('inserted rows: $result');

    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final db = await AppDatabase().database;

    final index = _items.indexWhere((item) => item.id == task.id);

    if (index >= 0) {
      _items[index] = task;

      final taskData = {
        'id': task.id,
        'title': task.title,
        'description': task.description ?? '',
        'date': FormatDateToSQLite.format(task.date),
        'priority': task.priority,
        'reminder': task.reminder ? 1 : 0,
        'reminderTime': task.reminderTime != null
            ? task.reminderTime!.toIso8601String()
            : '',
        'isCompleted': task.isCompleted ? 1 : 0,
      };

      final result = await db.update(
        DbTables.tasks.value,
        taskData,
        where: 'id = ?',
        whereArgs: [task.id],
      );

      if (task.reminder && task.reminderTime != null) {
        await notificationsService
            .showSchedulingNotification(CustomNotification(
          id: task.id,
          title: task.title,
          body:
              'You have a task due now. Click on the notification for more details.',
          payload: AppRoutes.HOME,
          schedule: task.reminderTime,
        ));
      }

      print('updated rows: $result');

      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    final db = await AppDatabase().database;

    final index = _items.indexWhere((item) => item.id == task.id);

    if (index >= 0) {
      await notificationsService.cancelNotification(task.id);

      final taskToRemove = _items[index];
      _items.remove(taskToRemove);
      _items.removeWhere((item) => item.id == taskToRemove.id);

      await db.delete(
        DbTables.tasks.value,
        where: 'id = ?',
        whereArgs: [task.id],
      );

      notifyListeners();
    }
  }
}
