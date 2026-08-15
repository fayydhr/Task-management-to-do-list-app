import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class GetNotesUseCase {
  final NoteRepository repository;
  GetNotesUseCase(this.repository);

  List<NoteEntity> execute() => repository.getNotes();
}

class AddNoteUseCase {
  final NoteRepository repository;
  AddNoteUseCase(this.repository);

  void execute(NoteEntity note) => repository.addNote(note);
}

class TogglePinNoteUseCase {
  final NoteRepository repository;
  TogglePinNoteUseCase(this.repository);

  void execute(String id) => repository.togglePinNote(id);
}

class DeleteNoteUseCase {
  final NoteRepository repository;
  DeleteNoteUseCase(this.repository);

  void execute(String id) => repository.deleteNote(id);
}
