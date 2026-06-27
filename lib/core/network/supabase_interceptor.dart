import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../services/local_storage/local_storage_service.dart';

class SupabaseInterceptor extends Interceptor {
  final LocalStorageService _storage;

  /// Invoked when the backend rejects the JWT (401). Wired to the AuthCubit
  /// so an expired session cleanly redirects the user back to login.
  void Function()? onUnauthorized;

  SupabaseInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getToken();
    if (token != null) {
      options.headers[ApiConstants.authHeader] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _storage.clearAll();
      onUnauthorized?.call();
    }
    handler.next(err);
  }
}
