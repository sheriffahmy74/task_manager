import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/task_entity.dart';

abstract class TasksRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks(String projectId);

  Future<Either<Failure, TaskEntity>> createTask({
    required String projectId,
    required String title,
    required String priority,
  });

  Future<Either<Failure, TaskEntity>> updateTaskStatus({
    required String taskId,
    required String status,
  });
}
