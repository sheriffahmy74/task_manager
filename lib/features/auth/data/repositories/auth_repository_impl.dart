import 'dart:convert';

import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_call_handler.dart';
import '../../../../core/services/local_storage/local_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final LocalStorageService _storage;
  final NetworkCallHandler _handler;

  AuthRepositoryImpl(this._datasource, this._storage, this._handler);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) {
    return _handler.handle(() async {
      final response = await _datasource.login(email, password);
      await _storage.saveToken(response.accessToken);
      await _storage.saveUserData(jsonEncode(response.user.toJson()));
      return response.user;
    });
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _handler.handle(() async {
      await _datasource.register(name, email, password);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> logout() {
    return _handler.handle(() async {
      // Best-effort remote logout — always clear local session regardless.
      try {
        await _datasource.logout();
      } catch (_) {}
      await _storage.clearAll();
      return unit;
    });
  }

  @override
  Future<Either<Failure, UserEntity>> getCachedUser() {
    return _handler.handle(() async {
      final token = await _storage.getToken();
      final userData = await _storage.getUserData();
      if (token == null || userData == null) {
        throw const CacheException(message: 'No cached session');
      }
      return UserModel.fromJson(
        jsonDecode(userData) as Map<String, dynamic>,
      );
    });
  }
}
