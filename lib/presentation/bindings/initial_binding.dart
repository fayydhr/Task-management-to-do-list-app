import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/datasources/local_storage_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../domain/usecases/task_usecases.dart';
import '../../domain/usecases/project_usecases.dart';
import '../../domain/usecases/note_usecases.dart';
import '../controllers/task_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Data Source
    final storage = GetStorage();
    final localDataSource = LocalStorageDataSourceImpl(storage);
    Get.lazyPut<LocalStorageDataSource>(() => localDataSource, fenix: true);

    // Repositories
    final taskRepo = TaskRepositoryImpl(localDataSource);
    final projectRepo = ProjectRepositoryImpl(localDataSource);
    final noteRepo = NoteRepositoryImpl(localDataSource);

    Get.lazyPut<TaskRepositoryImpl>(() => taskRepo, fenix: true);
    Get.lazyPut<ProjectRepositoryImpl>(() => projectRepo, fenix: true);
    Get.lazyPut<NoteRepositoryImpl>(() => noteRepo, fenix: true);

    // Use Cases
    final getTasks = GetTasksUseCase(taskRepo);
    final addTask = AddTaskUseCase(taskRepo);
    final toggleTaskStatus = ToggleTaskStatusUseCase(taskRepo);
    final deleteTask = DeleteTaskUseCase(taskRepo);

    final getProjects = GetProjectsUseCase(projectRepo);
    final addProject = AddProjectUseCase(projectRepo);
    final deleteProject = DeleteProjectUseCase(projectRepo);

    final getNotes = GetNotesUseCase(noteRepo);
    final addNote = AddNoteUseCase(noteRepo);
    final togglePinNote = TogglePinNoteUseCase(noteRepo);
    final deleteNote = DeleteNoteUseCase(noteRepo);

    // Controller
    Get.put<TaskController>(
      TaskController(
        getTasksUseCase: getTasks,
        addTaskUseCase: addTask,
        toggleTaskStatusUseCase: toggleTaskStatus,
        deleteTaskUseCase: deleteTask,
        getProjectsUseCase: getProjects,
        addProjectUseCase: addProject,
        deleteProjectUseCase: deleteProject,
        getNotesUseCase: getNotes,
        addNoteUseCase: addNote,
        togglePinNoteUseCase: togglePinNote,
        deleteNoteUseCase: deleteNote,
      ),
      permanent: true,
    );
  }
}
