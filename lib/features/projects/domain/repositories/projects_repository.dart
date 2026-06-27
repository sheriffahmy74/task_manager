import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/project_entity.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();

  Future<Either<Failure, ProjectEntity>> createProject({
    required String name,
    required String description,
  });

  Future<Either<Failure, Unit>> updateProjectStatus({
    required String projectId,
    required String status,
  });
}
