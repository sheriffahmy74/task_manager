import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class DioClient {
  DioClient._();

  static Dio create(Interceptor interceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          ApiConstants.apiKeyHeader: ApiConstants.apiKey,
        },
      ),
    );
    dio.interceptors.add(interceptor);
    return dio;
  }
}
