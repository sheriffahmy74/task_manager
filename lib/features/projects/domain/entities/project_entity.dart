import 'package:equatable/equatable.dart';

/// Allowed project `status` values on the backend (lowercase).
class ProjectStatus {
  ProjectStatus._();

  static const String pending = 'pending';
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
}

class ProjectEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String status;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  @override
  List<Object?> get props => [id, title, description, status];
}
