import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/get_projects_usecase.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final GetProjectsUseCase _getProjectsUseCase;

  ProjectsCubit(this._getProjectsUseCase) : super(const ProjectsInitial());

  Future<void> loadProjects() async {
    emit(const ProjectsLoading());
    final result = await _getProjectsUseCase(const NoParams());
    result.fold(
      (failure) => emit(ProjectsError(failure.message)),
      (projects) => emit(ProjectsLoaded(projects)),
    );
  }
}
