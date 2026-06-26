import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/api_constants.dart';
import 'local_storage_service.dart';

class SecureStorageImpl implements LocalStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageImpl(this._storage);

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: ApiConstants.tokenKey, value: token);

  @override
  Future<String?> getToken() =>
      _storage.read(key: ApiConstants.tokenKey);

  @override
  Future<void> saveUserData(String json) =>
      _storage.write(key: ApiConstants.userDataKey, value: json);

  @override
  Future<String?> getUserData() =>
      _storage.read(key: ApiConstants.userDataKey);

  @override
  Future<void> clearAll() => _storage.deleteAll();
}
