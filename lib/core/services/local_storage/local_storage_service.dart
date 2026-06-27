abstract class LocalStorageService {
  // Auth session
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveUserData(String json);
  Future<String?> getUserData();

  /// Clears only the auth session (token + user data).
  /// Device preferences (theme, locale) intentionally survive logout.
  Future<void> clearAll();

  // Preferences
  Future<void> saveThemeMode(String mode);
  Future<String?> getThemeMode();
  Future<void> saveLocale(String languageCode);
  Future<String?> getLocale();
}
