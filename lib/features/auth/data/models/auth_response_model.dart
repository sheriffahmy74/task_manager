import 'user_model.dart';

/// Wraps a Supabase auth session response: the access token + the user.
class AuthResponseModel {
  final String accessToken;
  final UserModel user;

  const AuthResponseModel({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Login returns { access_token, user: {...} }.
    final userJson = (json['user'] as Map<String, dynamic>?) ?? json;
    return AuthResponseModel(
      accessToken: (json['access_token'] ?? '').toString(),
      user: UserModel.fromJson(userJson),
    );
  }
}
