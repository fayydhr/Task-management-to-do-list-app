import '../../domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  ProjectModel({
    required super.id,
    required super.name,
    super.description,
    required super.colorValue,
    super.iconCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'colorValue': colorValue,
      'iconCode': iconCode,
    };
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      colorValue: json['colorValue'] ?? 0xFF6366F1,
      iconCode: json['iconCode'] ?? 0xe3af,
    );
  }

  factory ProjectModel.fromEntity(ProjectEntity entity) {
    return ProjectModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      colorValue: entity.colorValue,
      iconCode: entity.iconCode,
    );
  }
}
