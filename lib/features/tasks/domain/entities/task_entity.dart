import 'package:equatable/equatable.dart';

/// Allowed `task_status` enum values on the backend (uppercase).
class TaskStatus {
  TaskStatus._();

  static const String todo = 'TO_DO';
  static const String inProgress = 'IN_PROGRESS';
  static const String done = 'DONE';
}

/// Allowed `priority` values on the backend (lowercase).
class TaskPriority {
  TaskPriority._();

  static const String low = 'low';
  static const String medium = 'medium';
  static const String high = 'high';

  static const List<String> all = [low, medium, high];
}

class TaskEntity extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final String status;
  final String priority;

  const TaskEntity({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
  });

  bool get isDone => status == TaskStatus.done;

  @override
  List<Object?> get props => [id, projectId, title, description, status, priority];
}
