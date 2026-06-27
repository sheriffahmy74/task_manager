import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class CreateProjectUseCase
    implements UseCase<ProjectEntity, CreateProjectParams> {
  final ProjectsRepository _repository;

  CreateProjectUseCase(this._repository);

  @override
  Future<Either<Failure, ProjectEntity>> call(CreateProjectParams params) {
    return _repository.createProject(
      name: params.name,
      description: params.description,
    );
  }
}

class CreateProjectParams extends Equatable {
  final String name;
  final String description;

  const CreateProjectParams({required this.name, required this.description});

  @override
  List<Object?> get props => [name, description];
}
