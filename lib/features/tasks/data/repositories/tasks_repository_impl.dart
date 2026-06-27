import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_call_handler.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_datasource.dart';

class TasksRepositoryImpl implements TasksRepository {
  final TasksRemoteDatasource _datasource;
  final NetworkCallHandler _handler;

  TasksRepositoryImpl(this._datasource, this._handler);

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks(String projectId) {
    return _handler.handle(() => _datasource.getTasks(projectId));
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask({
    required String projectId,
    required String title,
    required String priority,
  }) {
    return _handler.handle(
      () => _datasource.createTask(
        projectId: projectId,
        title: title,
        priority: priority,
      ),
    );
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTaskStatus({
    required String taskId,
    required String status,
  }) {
    return _handler.handle(
      () => _datasource.updateTaskStatus(taskId: taskId, status: status),
    );
  }
}
