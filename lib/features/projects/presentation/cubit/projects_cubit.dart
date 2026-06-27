import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/create_project_usecase.dart';
import '../../domain/usecases/get_projects_usecase.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final GetProjectsUseCase _getProjectsUseCase;
  final CreateProjectUseCase _createProjectUseCase;

  ProjectsCubit(
    this._getProjectsUseCase,
    this._createProjectUseCase,
  ) : super(const ProjectsInitial());

  Future<void> loadProjects() async {
    emit(const ProjectsLoading());
    final result = await _getProjectsUseCase(const NoParams());
    result.fold(
      (failure) => emit(ProjectsError(failure.message)),
      (projects) => emit(ProjectsLoaded(projects)),
    );
  }

  Future<void> createProject({
    required String name,
    required String description,
  }) async {
    final current = _currentProjects();
    emit(ProjectsActionInProgress(current));
    final result = await _createProjectUseCase(
      CreateProjectParams(name: name, description: description),
    );
    result.fold(
      (failure) {
        emit(ProjectsActionFailure(current, failure.message));
        emit(ProjectsLoaded(current));
      },
      (project) {
        final updated = [project, ...current];
        emit(ProjectsActionSuccess(updated));
        emit(ProjectsLoaded(updated));
      },
    );
  }

  List<ProjectEntity> _currentProjects() {
    final state = this.state;
    return state is ProjectsWithData ? state.projects : const [];
  }
}
