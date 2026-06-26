abstract class LocalStorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveUserData(String json);
  Future<String?> getUserData();
  Future<void> clearAll();
}
