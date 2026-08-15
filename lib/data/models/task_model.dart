import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.projectName,
    required super.date,
    required super.time,
    required super.priority,
    super.isCompleted,
    required super.colorValue,
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
      time: json['time'] ?? '00:00',
      priority: json['priority'] ?? 'Sedang',
      isCompleted: json['isCompleted'] ?? false,
      colorValue: json['colorValue'] ?? 0xFF6366F1,
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      projectName: entity.projectName,
      date: entity.date,
      time: entity.time,
      priority: entity.priority,
      isCompleted: entity.isCompleted,
      colorValue: entity.colorValue,
    );
  }
}
