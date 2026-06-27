import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/project_model.dart';

abstract class ProjectsRemoteDatasource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> createProject(String name, String description);
  Future<void> updateProjectStatus(String projectId, String status);
}

class ProjectsRemoteDatasourceImpl implements ProjectsRemoteDatasource {
  final Dio _dio;

  ProjectsRemoteDatasourceImpl(this._dio);

  @override
  Future<List<ProjectModel>> getProjects() async {
    final response = await _dio.get(
      ApiConstants.projects,
      queryParameters: {'select': '*'},
    );
    final data = response.data as List<dynamic>;
    return data
        .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProjectModel> createProject(String name, String description) async {
    final response = await _dio.post(
      ApiConstants.projects,
      data: {'name': name, 'description': description},
      options: Options(
        headers: {
          ApiConstants.preferHeader: ApiConstants.preferReturnRepresentation,
        },
      ),
    );
    // PostgREST returns a list with the created row.
    final data = response.data as List<dynamic>;
    return ProjectModel.fromJson(data.first as Map<String, dynamic>);
  }

  @override
  Future<void> updateProjectStatus(String projectId, String status) async {
    await _dio.patch(
      ApiConstants.projects,
      queryParameters: {'id': 'eq.$projectId'},
      data: {'status': status},
    );
  }
}
