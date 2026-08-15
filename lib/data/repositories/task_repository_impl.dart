import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalStorageDataSource dataSource;
  TaskRepositoryImpl(this.dataSource);

  @override
  List<TaskEntity> getTasks() {
    return dataSource.getTasks();
  }

  @override
  void saveTasks(List<TaskEntity> tasks) {
    final models = tasks.map((e) => TaskModel.fromEntity(e)).toList();
    dataSource.saveTasks(models);
  }

  @override
  void addTask(TaskEntity task) {
    final tasks = getTasks();
    tasks.insert(0, task);
    saveTasks(tasks);
  }

  @override
  void toggleTaskStatus(String id) {
    final tasks = getTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      tasks[index].isCompleted = !tasks[index].isCompleted;
      saveTasks(tasks);
    }
  }

  @override
  void updateTask(TaskEntity task) {
    final tasks = getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      saveTasks(tasks);
    }
  }

  @override
  void deleteTask(String id) {
    final tasks = getTasks();
    tasks.removeWhere((t) => t.id == id);
    saveTasks(tasks);
  }
}
