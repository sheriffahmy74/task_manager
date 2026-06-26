import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/project_model.dart';

abstract class ProjectsRemoteDatasource {
  Future<List<ProjectModel>> getProjects();
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
}
