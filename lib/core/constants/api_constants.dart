class ApiConstants {
  ApiConstants._();

  // Single root URL — paths below include the /auth/v1 or /rest/v1 prefix.
  static const String baseUrl = 'https://ljumukgufcuhuodiyjxv.supabase.co';

  // Publishable (client-safe) key. Row Level Security on the backend
  // governs data access per authenticated user — never ship a secret key.
  static const String apiKey = 'sb_publishable_XsgyIpUWT2Y3O5QtBqZrvA_81WsUKRN';

  // Auth endpoints
  static const String login = '/auth/v1/token?grant_type=password';
  static const String register = '/auth/v1/signup';
  static const String logout = '/auth/v1/logout';

  // REST endpoints
  static const String projects = '/rest/v1/projects';
  static const String tasks = '/rest/v1/tasks';

  // Headers
  static const String apiKeyHeader = 'apikey';
  static const String authHeader = 'Authorization';
  static const String preferHeader = 'Prefer';
  static const String preferReturnRepresentation = 'return=representation';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeModeKey = 'theme_mode';
  static const String localeKey = 'locale';
}
