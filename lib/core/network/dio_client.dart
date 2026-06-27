import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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

    // Debug-only network logging. Headers and bodies are intentionally NOT
    // logged so the apikey, JWT and passwords never leak — and this whole
    // block is stripped from release builds.
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
          error: true,
          logPrint: (obj) => debugPrint('[Dio] $obj'),
        ),
      );
    }

    return dio;
  }
}
