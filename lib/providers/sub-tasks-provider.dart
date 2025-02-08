import 'package:flutter/material.dart';
import 'package:taskly/models/sub-task.dart';

class SubTasksProvider with ChangeNotifier {
  List<SubTask> _items = [];

  List<SubTask> get items {
    return [..._items];
  }

  List<SubTask> getSubTasksByTaskId(int taskId) {
    final subtasks =
        _items.where((subtask) => subtask.taskId == taskId).toList();

    return subtasks;
  }

  Future<void> saveSubTask(SubTask subtask) async {
    print('sub task to add: $subtask');

    _items.add(subtask);

    print('sub-task was add successfully!');

    notifyListeners();
  }

  Future<void> updateSubTask(SubTask subtask) async {
    final index = _items.indexWhere((item) => item.id == subtask.id);

    if (index >= 0) {
      _items[index] = subtask;

      notifyListeners();
    }
  }
}
