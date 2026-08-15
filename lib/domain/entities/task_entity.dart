class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String projectName;
  final DateTime date;
  final String time;
  final String priority;
  bool isCompleted;
  final int colorValue;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.projectName,
    required this.date,
    required this.time,
    required this.priority,
    this.isCompleted = false,
    required this.colorValue,
  });
}
