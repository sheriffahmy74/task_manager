import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_call_handler.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_remote_datasource.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsRemoteDatasource _datasource;
  final NetworkCallHandler _handler;

  ProjectsRepositoryImpl(this._datasource, this._handler);

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() {
    return _handler.handle(() => _datasource.getProjects());
  }

  @override
  Future<Either<Failure, ProjectEntity>> createProject({
    required String name,
    required String description,
  }) {
    return _handler.handle(
      () => _datasource.createProject(name, description),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateProjectStatus({
    required String projectId,
    required String status,
  }) {
    return _handler.handle(() async {
      await _datasource.updateProjectStatus(projectId, status);
      return unit;
    });
  }
}
