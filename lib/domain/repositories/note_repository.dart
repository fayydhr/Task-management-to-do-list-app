import '../entities/note_entity.dart';

abstract class NoteRepository {
  List<NoteEntity> getNotes();
  void saveNotes(List<NoteEntity> notes);
  void addNote(NoteEntity note);
  void togglePinNote(String id);
  void deleteNote(String id);
}
