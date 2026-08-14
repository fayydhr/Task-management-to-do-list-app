class TaskModel {
  String id;
  String title;
  String description;
  String projectName;
  DateTime date;
  String time;
  String priority; // 'Tinggi', 'Sedang', 'Rendah'
  bool isCompleted;
  int colorValue;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.projectName,
    required this.date,
    this.time = '09:00',
    this.priority = 'Sedang',
    this.isCompleted = false,
    this.colorValue = 0xFF6366F1,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'projectName': projectName,
      'date': date.toIso8601String(),
      'time': time,
      'priority': priority,
      'isCompleted': isCompleted,
      'colorValue': colorValue,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      projectName: json['projectName'] ?? 'Umum',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      time: json['time'] ?? '09:00',
      priority: json['priority'] ?? 'Sedang',
      isCompleted: json['isCompleted'] ?? false,
      colorValue: json['colorValue'] ?? 0xFF6366F1,
    );
  }
}
