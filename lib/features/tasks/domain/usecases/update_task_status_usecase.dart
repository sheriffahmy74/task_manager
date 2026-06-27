import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class UpdateTaskStatusUseCase
    implements UseCase<TaskEntity, UpdateTaskParams> {
  final TasksRepository _repository;

  UpdateTaskStatusUseCase(this._repository);

  @override
  Future<Either<Failure, TaskEntity>> call(UpdateTaskParams params) {
    return _repository.updateTaskStatus(
      taskId: params.taskId,
      status: params.status,
    );
  }
}

class UpdateTaskParams extends Equatable {
  final String taskId;
  final String status;

  const UpdateTaskParams({required this.taskId, required this.status});

  @override
  List<Object?> get props => [taskId, status];
}
