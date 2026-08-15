import '../../domain/entities/note_entity.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    required super.id,
    required super.title,
    required super.content,
    required super.category,
    required super.date,
    super.isPinned,
    required super.colorValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'date': date.toIso8601String(),
      'isPinned': isPinned,
      'colorValue': colorValue,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? 'Umum',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      isPinned: json['isPinned'] ?? false,
      colorValue: json['colorValue'] ?? 0xFFFFF4BD,
    );
  }

  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      category: entity.category,
      date: entity.date,
      isPinned: entity.isPinned,
      colorValue: entity.colorValue,
    );
  }
}
