import 'dart:math';

import 'package:taskly/models/task.dart';

final List<Task> dummyTasksList = [
  Task(
    id: (Random().nextDouble() * 256).toString(),
    title: 'Random Title 1',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    priority: 1,
    date: DateTime.now(),
    reminder: true,
    reminderTime: DateTime.now().add(Duration(hours: 2, minutes: 30)),
  ),
  Task(
    id: (Random().nextDouble() * 256).toString(),
    title: 'Random Title 2',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    priority: 2,
    date: DateTime.now(),
  ),
  Task(
    id: (Random().nextDouble() * 256).toString(),
    title: 'Random Title 3',
    date: DateTime.now(),
    reminder: true,
    reminderTime: DateTime.now().add(Duration(hours: 1, minutes: 30)),
  ),
  Task(
    id: (Random().nextDouble() * 256).toString(),
    title: 'Random Title 4',
    priority: 2,
    date: DateTime.now(),
    reminder: true,
    reminderTime: DateTime.now().add(Duration(minutes: 15)),
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
  Task(
    id: (Random().nextDouble() * 256).toString(),
    title: 'Random Title 5',
    date: DateTime.now(),
  ),
  Task(
    id: (Random().nextDouble() * 256).toString(),
    title: 'Random Title 6',
    date: DateTime.now(),
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
    priority: 3,
  ),
  Task(
    id: (Random().nextDouble() * 256).toString(),
    title: 'Random Title 7',
    date: DateTime.now(),
    priority: 3,
    reminder: true,
    reminderTime: DateTime.now().add(Duration(hours: 2, minutes: 10)),
  ),
];
