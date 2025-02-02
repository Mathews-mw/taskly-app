class SubTask {
  final String id;
  final String taskId;
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
}
