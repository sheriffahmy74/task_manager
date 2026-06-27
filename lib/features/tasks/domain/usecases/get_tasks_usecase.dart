import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase implements UseCase<List<TaskEntity>, GetTasksParams> {
  final TasksRepository _repository;

  GetTasksUseCase(this._repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(GetTasksParams params) {
    return _repository.getTasks(params.projectId);
  }
}

class GetTasksParams extends Equatable {
  final String projectId;

  const GetTasksParams(this.projectId);

  @override
  List<Object?> get props => [projectId];
}
