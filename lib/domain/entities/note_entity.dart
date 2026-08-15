class NoteEntity {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime date;
  bool isPinned;
  final int colorValue;

  NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    this.isPinned = false,
    required this.colorValue,
  });
}
