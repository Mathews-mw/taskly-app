class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;
  final DateTime? schedule;

  CustomNotification({
    required this.id,
    this.title,
    this.body,
    this.payload,
    this.schedule,
  });
}
