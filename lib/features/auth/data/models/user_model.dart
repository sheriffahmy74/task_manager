import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  /// Handles both the Supabase user shape (name under `user_metadata`)
  /// and the flat shape produced by [toJson] for local caching.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final metadata = json['user_metadata'] as Map<String, dynamic>?;
    return UserModel(
      id: (json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: (json['name'] ?? metadata?['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
