part of 'projects_cubit.dart';

sealed class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Base for states that carry the current project list so the list
/// stays visible during the create action.
sealed class ProjectsWithData extends ProjectsState {
  final List<ProjectEntity> projects;

  const ProjectsWithData(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ProjectsLoaded extends ProjectsWithData {
  const ProjectsLoaded(super.projects);
}

class ProjectsActionInProgress extends ProjectsWithData {
  const ProjectsActionInProgress(super.projects);
}

class ProjectsActionSuccess extends ProjectsWithData {
  const ProjectsActionSuccess(super.projects);
}

class ProjectsActionFailure extends ProjectsWithData {
  final String message;

  const ProjectsActionFailure(super.projects, this.message);

  @override
  List<Object?> get props => [projects, message];
}
