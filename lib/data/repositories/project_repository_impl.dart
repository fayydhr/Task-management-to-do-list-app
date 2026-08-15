import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final LocalStorageDataSource dataSource;
  ProjectRepositoryImpl(this.dataSource);

  @override
  List<ProjectEntity> getProjects() {
    return dataSource.getProjects();
  }

  @override
  void saveProjects(List<ProjectEntity> projects) {
    final models = projects.map((e) => ProjectModel.fromEntity(e)).toList();
    dataSource.saveProjects(models);
  }

  @override
  void addProject(ProjectEntity project) {
    final projects = getProjects();
    projects.add(project);
    saveProjects(projects);
  }

  @override
  void deleteProject(String id) {
    final projects = getProjects();
    projects.removeWhere((p) => p.id == id);
    saveProjects(projects);
  }
}
