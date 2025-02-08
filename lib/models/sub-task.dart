class SubTask {
  final int id;
  final int taskId;
  final String title;
  final String? description;
  final bool isCompleted;

  SubTask({
    required this.id,
    required this.taskId,
    required this.title,
    this.description,
    this.isCompleted = false,
  });

  set title(String title) {
    this.title = title;
  }

  set description(String? description) {
    this.description = description;
  }

  set isCompleted(bool isCompleted) {
    this.isCompleted = isCompleted;
  }

  @override
  String toString() {
    return 'SubTask(id: $id, taskId: $taskId, title: $title, description: $description, isCompleted: $isCompleted)';
  }
}
