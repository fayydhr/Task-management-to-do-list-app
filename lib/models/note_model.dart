class NoteModel {
  String id;
  String title;
  String content;
  String category;
  DateTime date;
  bool isPinned;
  int colorValue;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
    this.isPinned = false,
    required this.colorValue,
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
}
