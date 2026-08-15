import 'package:get/get.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/task_usecases.dart';
import '../../domain/usecases/project_usecases.dart';
import '../../domain/usecases/note_usecases.dart';

class TaskController extends GetxController {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final ToggleTaskStatusUseCase toggleTaskStatusUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  final GetProjectsUseCase getProjectsUseCase;
  final AddProjectUseCase addProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;

  final GetNotesUseCase getNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final TogglePinNoteUseCase togglePinNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;

  TaskController({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.toggleTaskStatusUseCase,
    required this.deleteTaskUseCase,
    required this.getProjectsUseCase,
    required this.addProjectUseCase,
    required this.deleteProjectUseCase,
    required this.getNotesUseCase,
    required this.addNoteUseCase,
    required this.togglePinNoteUseCase,
    required this.deleteNoteUseCase,
  });

  var tasks = <TaskEntity>[].obs;
  var projects = <ProjectEntity>[].obs;
  var notes = <NoteEntity>[].obs;

  var selectedCategory = 'Semua'.obs;
  var selectedFilter = 'All'.obs; // All, To Do, In Progress, Completed
  var searchQuery = ''.obs;
  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  void loadAllData() {
    tasks.assignAll(getTasksUseCase.execute());
    projects.assignAll(getProjectsUseCase.execute());
    notes.assignAll(getNotesUseCase.execute());
  }

  // --- Task Methods ---
  void addTask(TaskEntity task) {
    addTaskUseCase.execute(task);
    tasks.assignAll(getTasksUseCase.execute());
    Get.snackbar(
      'Berhasil Ditambahkan',
      'Tugas "${task.title}" telah dibuat',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void toggleTaskStatus(String id) {
    toggleTaskStatusUseCase.execute(id);
    tasks.assignAll(getTasksUseCase.execute());
  }

  void deleteTask(String id) {
    deleteTaskUseCase.execute(id);
    tasks.assignAll(getTasksUseCase.execute());
    Get.snackbar(
      'Dihapus',
      'Tugas telah dihapus',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // --- Project Methods ---
  void addProject(ProjectEntity project) {
    addProjectUseCase.execute(project);
    projects.assignAll(getProjectsUseCase.execute());
    Get.snackbar(
      'Proyek Baru Dibuat',
      'Proyek "${project.name}" berhasil dibuat',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void deleteProject(String id) {
    deleteProjectUseCase.execute(id);
    projects.assignAll(getProjectsUseCase.execute());
  }

  // --- Note Methods ---
  void addNote(NoteEntity note) {
    addNoteUseCase.execute(note);
    notes.assignAll(getNotesUseCase.execute());
    Get.snackbar(
      'Catatan Dibuat',
      'Catatan "${note.title}" telah disimpan',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void togglePinNote(String id) {
    togglePinNoteUseCase.execute(id);
    notes.assignAll(getNotesUseCase.execute());
  }

  void deleteNote(String id) {
    deleteNoteUseCase.execute(id);
    notes.assignAll(getNotesUseCase.execute());
    Get.snackbar(
      'Dihapus',
      'Catatan telah dihapus',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // --- Computed Getters ---
  List<TaskEntity> get todayTasks {
    final sel = selectedDate.value;
    return tasks.where((task) {
      return task.date.year == sel.year &&
          task.date.month == sel.month &&
          task.date.day == sel.day;
    }).toList();
  }

  List<TaskEntity> get filteredTodayTasks {
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
}
