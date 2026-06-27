import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/task_model.dart';

abstract class TasksRemoteDatasource {
  Future<List<TaskModel>> getTasks(String projectId);
  Future<TaskModel> createTask({
    required String projectId,
    required String title,
    required String priority,
  });
  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required String status,
  });
}

class TasksRemoteDatasourceImpl implements TasksRemoteDatasource {
  final Dio _dio;

  TasksRemoteDatasourceImpl(this._dio);

  @override
  Future<List<TaskModel>> getTasks(String projectId) async {
    final response = await _dio.get(
      ApiConstants.tasks,
      queryParameters: {
        'project_id': 'eq.$projectId',
        'select': '*',
        'order': 'created_at.desc',
      },
    );
    final data = response.data as List<dynamic>;
    return data
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TaskModel> createTask({
    required String projectId,
    required String title,
    required String priority,
  }) async {
    final response = await _dio.post(
      ApiConstants.tasks,
      data: {
        'project_id': projectId,
        'title': title,
        'priority': priority,
      },
      options: Options(
        headers: {
          ApiConstants.preferHeader: ApiConstants.preferReturnRepresentation,
        },
      ),
    );
    // PostgREST returns a list with the created row.
    final data = response.data as List<dynamic>;
    return TaskModel.fromJson(data.first as Map<String, dynamic>);
  }

  @override
  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required String status,
  }) async {
    final response = await _dio.patch(
      ApiConstants.tasks,
      queryParameters: {'id': 'eq.$taskId'},
      data: {'status': status},
      options: Options(
        headers: {
          ApiConstants.preferHeader: ApiConstants.preferReturnRepresentation,
        },
      ),
    );
    final data = response.data as List<dynamic>;
    return TaskModel.fromJson(data.first as Map<String, dynamic>);
  }
}
