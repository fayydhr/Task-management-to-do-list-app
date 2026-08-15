import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class GetProjectsUseCase {
  final ProjectRepository repository;
  GetProjectsUseCase(this.repository);

  List<ProjectEntity> execute() => repository.getProjects();
}

class AddProjectUseCase {
  final ProjectRepository repository;
  AddProjectUseCase(this.repository);

  void execute(ProjectEntity project) => repository.addProject(project);
}

class DeleteProjectUseCase {
  final ProjectRepository repository;
  DeleteProjectUseCase(this.repository);

  void execute(String id) => repository.deleteProject(id);
}
