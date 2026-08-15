import 'package:get_storage/get_storage.dart';
import '../models/task_model.dart';
import '../models/project_model.dart';
import '../models/note_model.dart';

abstract class LocalStorageDataSource {
  List<TaskModel> getTasks();
  void saveTasks(List<TaskModel> tasks);

  List<ProjectModel> getProjects();
  void saveProjects(List<ProjectModel> projects);

  List<NoteModel> getNotes();
  void saveNotes(List<NoteModel> notes);
}

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  final GetStorage storage;
  LocalStorageDataSourceImpl(this.storage);

  @override
  List<TaskModel> getTasks() {
    List? stored = storage.read<List>('tasks');
    if (stored != null && stored.isNotEmpty) {
      return stored.map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    final now = DateTime.now();
    final defaultTasks = [
      TaskModel(
        id: 't1',
        title: 'Review Prototype Figma GetX App',
        description: 'Cek flow antarmuka 4 screen utama',
        projectName: 'Desain UI/UX',
        date: now,
        time: '09:00',
        priority: 'Tinggi',
        isCompleted: true,
        colorValue: 0xFF6366F1,
      ),
      TaskModel(
        id: 't2',
        title: 'Selesaikan Setup State Management GetX',
        description: 'Buat TaskController & binding routes',
        projectName: 'Pengembangan Flutter',
        date: now,
        time: '11:30',
        priority: 'Tinggi',
        isCompleted: false,
        colorValue: 0xFF10B981,
      ),
      TaskModel(
        id: 't3',
        title: 'Meeting Koordinasi Tim Dev',
        description: 'Bahas integrasi backend & deployment',
        projectName: 'Pekerjaan Kantor',
        date: now,
        time: '14:00',
        priority: 'Sedang',
        isCompleted: false,
        colorValue: 0xFFF59E0B,
      ),
      TaskModel(
        id: 't4',
        title: 'Olahraga Sore 30 Menit',
        description: 'Jogging di taman dekat rumah',
        projectName: 'Personal',
        date: now,
        time: '17:00',
        priority: 'Rendah',
        isCompleted: false,
        colorValue: 0xFFEC4899,
      ),
    ];
    saveTasks(defaultTasks);
    return defaultTasks;
  }

  @override
  void saveTasks(List<TaskModel> tasks) {
    storage.write('tasks', tasks.map((e) => e.toJson()).toList());
  }

  @override
  List<ProjectModel> getProjects() {
    List? stored = storage.read<List>('projects');
    if (stored != null && stored.isNotEmpty) {
      return stored.map((e) => ProjectModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    final defaultProjects = [
      ProjectModel(id: 'p1', name: 'Desain UI/UX', description: 'Tampilan aplikasi mobile & web', colorValue: 0xFF6366F1, iconCode: 0xe1b1),
      ProjectModel(id: 'p2', name: 'Pengembangan Flutter', description: 'Integrasi state management & API', colorValue: 0xFF10B981, iconCode: 0xe1d7),
      ProjectModel(id: 'p3', name: 'Pekerjaan Kantor', description: 'Laporan mingguan & presentasi', colorValue: 0xFFF59E0B, iconCode: 0xe3af),
      ProjectModel(id: 'p4', name: 'Personal', description: 'Olahraga, baca buku & belanja', colorValue: 0xFFEC4899, iconCode: 0xe491),
    ];
    saveProjects(defaultProjects);
    return defaultProjects;
  }

  @override
  void saveProjects(List<ProjectModel> projects) {
    storage.write('projects', projects.map((e) => e.toJson()).toList());
  }

  @override
  List<NoteModel> getNotes() {
    List? stored = storage.read<List>('notes');
    if (stored != null && stored.isNotEmpty) {
      return stored.map((e) => NoteModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    final defaultNotes = [
      NoteModel(
        id: 'n1',
        title: 'Ide Fitur Dark Mode',
        content: 'Tambahkan toggle mode gelap dengan palette warna slate 900 & aksen ungu pastel.',
        category: 'Desain UI/UX',
        date: DateTime.now(),
        isPinned: true,
        colorValue: 0xFFFFF4BD,
      ),
      NoteModel(
        id: 'n2',
        title: 'Checklist Rapat Klien',
        content: '- Demo prototype mobile\n- Bahas alokasi deadline\n- Konfirmasi skema warna',
        category: 'Pekerjaan Kantor',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isPinned: true,
        colorValue: 0xFFFFD6EC,
      ),
      NoteModel(
        id: 'n3',
        title: 'Daftar Buku Pilihan',
        content: '1. Clean Code\n2. Atomic Habits\n3. Designing Data-Intensive Applications',
        category: 'Personal',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isPinned: false,
        colorValue: 0xFFE8DDFF,
      ),
      NoteModel(
        id: 'n4',
        title: 'Refactoring API Service',
        content: 'Gunakan GetConnect / Dio dengan interceptor untuk handle refresh token.',
        category: 'Pengembangan Flutter',
        date: DateTime.now().subtract(const Duration(days: 3)),
        isPinned: false,
        colorValue: 0xFFD2E0FB,
      ),
    ];
    saveNotes(defaultNotes);
    return defaultNotes;
  }

  @override
  void saveNotes(List<NoteModel> notes) {
    storage.write('notes', notes.map((e) => e.toJson()).toList());
  }
}
