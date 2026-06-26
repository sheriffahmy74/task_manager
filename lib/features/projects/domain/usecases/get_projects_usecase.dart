import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase implements UseCase<List<ProjectEntity>, NoParams> {
  final ProjectsRepository _repository;

  GetProjectsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ProjectEntity>>> call(NoParams params) {
    return _repository.getProjects();
  }
}
