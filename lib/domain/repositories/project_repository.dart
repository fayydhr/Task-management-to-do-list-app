import '../entities/project_entity.dart';

abstract class ProjectRepository {
  List<ProjectEntity> getProjects();
  void saveProjects(List<ProjectEntity> projects);
  void addProject(ProjectEntity project);
  void deleteProject(String id);
}
