import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final LocalStorageDataSource dataSource;
  NoteRepositoryImpl(this.dataSource);

  @override
  List<NoteEntity> getNotes() {
    return dataSource.getNotes();
  }

  @override
  void saveNotes(List<NoteEntity> notes) {
    final models = notes.map((e) => NoteModel.fromEntity(e)).toList();
    dataSource.saveNotes(models);
  }

  @override
  void addNote(NoteEntity note) {
    final notes = getNotes();
    notes.insert(0, note);
    saveNotes(notes);
  }

  @override
  void togglePinNote(String id) {
    final notes = getNotes();
    final index = notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      notes[index].isPinned = !notes[index].isPinned;
      saveNotes(notes);
    }
  }

  @override
  void deleteNote(String id) {
    final notes = getNotes();
    notes.removeWhere((n) => n.id == id);
    saveNotes(notes);
  }
}
