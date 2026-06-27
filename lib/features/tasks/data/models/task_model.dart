import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.projectId,
    required super.title,
    required super.description,
    required super.status,
    required super.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: (json['id'] ?? '').toString(),
      projectId: (json['project_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      status: (json['status'] ?? TaskStatus.todo).toString(),
      priority: (json['priority'] ?? TaskPriority.medium).toString(),
    );
  }
}
