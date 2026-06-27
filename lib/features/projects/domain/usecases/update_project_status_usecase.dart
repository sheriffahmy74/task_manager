import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/projects_repository.dart';

class UpdateProjectStatusUseCase
    implements UseCase<Unit, UpdateProjectStatusParams> {
  final ProjectsRepository _repository;

  UpdateProjectStatusUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateProjectStatusParams params) {
    return _repository.updateProjectStatus(
      projectId: params.projectId,
      status: params.status,
    );
  }
}

class UpdateProjectStatusParams extends Equatable {
  final String projectId;
  final String status;

  const UpdateProjectStatusParams({
    required this.projectId,
    required this.status,
  });

  @override
  List<Object?> get props => [projectId, status];
}
