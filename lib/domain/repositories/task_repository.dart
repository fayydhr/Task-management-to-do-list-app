import '../entities/task_entity.dart';

abstract class TaskRepository {
  List<TaskEntity> getTasks();
  void saveTasks(List<TaskEntity> tasks);
  void addTask(TaskEntity task);
  void toggleTaskStatus(String id);
  void deleteTask(String id);
}
