import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/app_strings.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';

class NetworkCallHandler {
  /// Wraps any async call (network or cache) and converts thrown
  /// exceptions into typed [Failure]s. Datasources stay try/catch-free.
  Future<Either<Failure, T>> handle<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return right(result);
    } on DioException catch (e) {
      return left(_mapDioException(e));
    } on UnauthorizedException {
      return left(const UnauthorizedFailure(message: AppStrings.unauthorized));
    } on NetworkException {
      return left(const NetworkFailure(message: AppStrings.noInternet));
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  Failure _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: AppStrings.noInternet);
      default:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return const UnauthorizedFailure(message: AppStrings.unauthorized);
        }
        return ServerFailure(message: _extractMessage(e));
    }
  }

  String _extractMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['msg'] ??
          data['error_description'] ??
          data['message'] ??
          data['error'];
      if (msg != null) return msg.toString();
    }
    return AppStrings.serverError;
  }
}
