import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/project_entity.dart';

abstract class ProjectsRepository {
  Future<Either<Failure, List<ProjectEntity>>> getProjects();
}
