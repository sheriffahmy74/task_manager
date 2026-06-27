import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/tasks_repository.dart';

class CreateTaskUseCase implements UseCase<TaskEntity, CreateTaskParams> {
  final TasksRepository _repository;

  CreateTaskUseCase(this._repository);

  @override
  Future<Either<Failure, TaskEntity>> call(CreateTaskParams params) {
    return _repository.createTask(
      projectId: params.projectId,
      title: params.title,
      priority: params.priority,
    );
  }
}

class CreateTaskParams extends Equatable {
  final String projectId;
  final String title;
  final String priority;

  const CreateTaskParams({
    required this.projectId,
    required this.title,
    required this.priority,
  });

  @override
  List<Object?> get props => [projectId, title, priority];
}
