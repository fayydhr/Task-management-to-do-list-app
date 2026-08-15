import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/task_model.dart';
import '../models/project_model.dart';

import '../models/note_model.dart';

class TaskController extends GetxController {
  final _storage = GetStorage();

  var tasks = <TaskModel>[].obs;
  var projects = <ProjectModel>[].obs;
  var notes = <NoteModel>[].obs;

  var selectedCategory = 'Semua'.obs;
  var selectedFilter = 'All'.obs; // All, To Do, In Progress, Completed
  var searchQuery = ''.obs;
  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
    loadNotes();
  }

  void loadData() {
    List? storedTasks = _storage.read<List>('tasks');
    List? storedProjects = _storage.read<List>('projects');

    if (storedProjects != null && storedProjects.isNotEmpty) {
      projects.assignAll(storedProjects.map((e) => ProjectModel.fromJson(Map<String, dynamic>.from(e))).toList());
    } else {
      // Default initial projects
      projects.assignAll([
        ProjectModel(id: 'p1', name: 'Desain UI/UX', description: 'Tampilan aplikasi mobile & web', colorValue: 0xFF6366F1, iconCode: 0xe1b1),
        ProjectModel(id: 'p2', name: 'Pengembangan Flutter', description: 'Integrasi state management & API', colorValue: 0xFF10B981, iconCode: 0xe1d7),
        ProjectModel(id: 'p3', name: 'Pekerjaan Kantor', description: 'Laporan mingguan & presentasi', colorValue: 0xFFF59E0B, iconCode: 0xe3af),
        ProjectModel(id: 'p4', name: 'Personal', description: 'Olahraga, baca buku & belanja', colorValue: 0xFFEC4899, iconCode: 0xe491),
      ]);
      saveProjects();
    }

    if (storedTasks != null && storedTasks.isNotEmpty) {
      tasks.assignAll(storedTasks.map((e) => TaskModel.fromJson(Map<String, dynamic>.from(e))).toList());
    } else {
      // Default initial tasks for today demo
      final now = DateTime.now();
      tasks.assignAll([
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
      ]);
      saveTasks();
    }
  }

  void saveTasks() {
    _storage.write('tasks', tasks.map((e) => e.toJson()).toList());
  }

  void saveProjects() {
    _storage.write('projects', projects.map((e) => e.toJson()).toList());
  }

  // Task Operations
  void addTask(TaskModel task) {
    tasks.insert(0, task);
    saveTasks();
    Get.snackbar(
      'Berhasil Ditambahkan',
      'Tugas "${task.title}" telah dibuat',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void toggleTaskStatus(String id) {
    int index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      tasks.refresh();
      saveTasks();
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    saveTasks();
    Get.snackbar(
      'Dihapus',
      'Tugas telah dihapus',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Project Operations
  void addProject(ProjectModel project) {
    projects.add(project);
    saveProjects();
    Get.snackbar(
      'Proyek Baru Dibuat',
      'Proyek "${project.name}" berhasil dibuat',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void deleteProject(String id) {
    String projName = projects.firstWhere((p) => p.id == id, orElse: () => ProjectModel(id: '', name: '')).name;
    projects.removeWhere((p) => p.id == id);
    tasks.removeWhere((t) => t.projectName == projName);
    saveProjects();
    saveTasks();
  }

  // Computed Getters
  List<TaskModel> get todayTasks {
    final sel = selectedDate.value;
    return tasks.where((task) {
      return task.date.year == sel.year &&
          task.date.month == sel.month &&
          task.date.day == sel.day;
    }).toList();
  }

  List<TaskModel> get filteredTodayTasks {
    var list = todayTasks;
    if (searchQuery.value.isNotEmpty) {
      list = list.where((t) => t.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }

    final filter = selectedFilter.value;
    if (filter == 'To Do' || filter == 'Pending') {
      list = list.where((t) => !t.isCompleted).toList();
    } else if (filter == 'In Progress') {
      list = list.where((t) => !t.isCompleted).toList();
    } else if (filter == 'Completed' || filter == 'Selesai') {
      list = list.where((t) => t.isCompleted).toList();
    } else if (filter == 'Prioritas Tinggi') {
      list = list.where((t) => t.priority == 'Tinggi').toList();
    }

    return list;
  }

  int get completedTodayCount => todayTasks.where((t) => t.isCompleted).length;
  int get pendingTodayCount => todayTasks.where((t) => !t.isCompleted).length;

  double get todayProgressRatio {
    if (todayTasks.isEmpty) return 0.0;
    return completedTodayCount / todayTasks.length;
  }

  int getTaskCountForProject(String projectName) {
    return tasks.where((t) => t.projectName == projectName).length;
  }

  double getProjectProgress(String projectName) {
    final projTasks = tasks.where((t) => t.projectName == projectName).toList();
    if (projTasks.isEmpty) return 0.0;
    final done = projTasks.where((t) => t.isCompleted).length;
    return done / projTasks.length;
  }

  // --- Note Operations ---
  void loadNotes() {
    List? storedNotes = _storage.read<List>('notes');
    if (storedNotes != null && storedNotes.isNotEmpty) {
      notes.assignAll(storedNotes.map((e) => NoteModel.fromJson(Map<String, dynamic>.from(e))).toList());
    } else {
      notes.assignAll([
        NoteModel(
          id: 'n1',
          title: 'Ide Fitur Dark Mode 🌙',
          content: 'Tambahkan toggle mode gelap dengan palette warna slate 900 & aksen ungu pastel.',
          category: 'Desain UI/UX',
          date: DateTime.now(),
          isPinned: true,
          colorValue: 0xFFFFF4BD, // Pastel Yellow
        ),
        NoteModel(
          id: 'n2',
          title: 'Checklist Rapat Klien 📋',
          content: '- Demo prototype mobile\n- Bahas alokasi deadline\n- Konfirmasi skema warna',
          category: 'Pekerjaan Kantor',
          date: DateTime.now().subtract(const Duration(days: 1)),
          isPinned: true,
          colorValue: 0xFFFFD6EC, // Pastel Pink
        ),
        NoteModel(
          id: 'n3',
          title: 'Daftar Buku Pilihan 📚',
          content: '1. Clean Code\n2. Atomic Habits\n3. Designing Data-Intensive Applications',
          category: 'Personal',
          date: DateTime.now().subtract(const Duration(days: 2)),
          isPinned: false,
          colorValue: 0xFFE8DDFF, // Pastel Purple
        ),
        NoteModel(
          id: 'n4',
          title: 'Refactoring API Service ⚡',
          content: 'Gunakan GetConnect / Dio dengan interceptor untuk handle refresh token.',
          category: 'Pengembangan Flutter',
          date: DateTime.now().subtract(const Duration(days: 3)),
          isPinned: false,
          colorValue: 0xFFD2E0FB, // Pastel Blue
        ),
      ]);
      saveNotes();
    }
  }

  void saveNotes() {
    _storage.write('notes', notes.map((e) => e.toJson()).toList());
  }

  void addNote(NoteModel note) {
    notes.insert(0, note);
    saveNotes();
    Get.snackbar(
      'Catatan Dibuat',
      'Catatan "${note.title}" telah disimpan',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void togglePinNote(String id) {
    int index = notes.indexWhere((n) => n.id == id);
    if (index != -1) {
      notes[index].isPinned = !notes[index].isPinned;
      notes.refresh();
      saveNotes();
    }
  }

  void deleteNote(String id) {
    notes.removeWhere((n) => n.id == id);
    saveNotes();
    Get.snackbar(
      'Dihapus',
      'Catatan telah dihapus',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
