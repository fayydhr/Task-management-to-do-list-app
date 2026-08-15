class ProjectEntity {
  final String id;
  final String name;
  final String description;
  final int colorValue;
  final int iconCode;

  ProjectEntity({
    required this.id,
    required this.name,
    this.description = '',
    required this.colorValue,
    this.iconCode = 0xe3af,
  });
}
