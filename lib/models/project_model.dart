class ProjectModel {
  String id;
  String name;
  String description;
  int colorValue;
  int iconCode;

  ProjectModel({
    required this.id,
    required this.name,
    this.description = '',
    this.colorValue = 0xFF6366F1,
    this.iconCode = 0xe3af, // default work / folder icon
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
}
