import 'package:dio/dio.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthResponseModel> login(String email, String password);
  Future<void> register(String name, String email, String password);
  Future<void> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> register(String name, String email, String password) async {
    await _dio.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'data': {'name': name},
      },
    );
  }

  @override
  Future<void> logout() async {
    await _dio.post(ApiConstants.logout);
  }
}
