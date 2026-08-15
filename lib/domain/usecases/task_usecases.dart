import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;
  GetTasksUseCase(this.repository);

  List<TaskEntity> execute() => repository.getTasks();
}

class AddTaskUseCase {
  final TaskRepository repository;
  AddTaskUseCase(this.repository);

  void execute(TaskEntity task) => repository.addTask(task);
}

class ToggleTaskStatusUseCase {
  final TaskRepository repository;
  ToggleTaskStatusUseCase(this.repository);

  void execute(String id) => repository.toggleTaskStatus(id);
}

class DeleteTaskUseCase {
  final TaskRepository repository;
  DeleteTaskUseCase(this.repository);

  void execute(String id) => repository.deleteTask(id);
}
