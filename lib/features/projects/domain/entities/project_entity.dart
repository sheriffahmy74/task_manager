import 'package:equatable/equatable.dart';

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
