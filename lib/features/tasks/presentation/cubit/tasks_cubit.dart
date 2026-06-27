import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../projects/domain/entities/project_entity.dart';
import '../../../projects/domain/usecases/update_project_status_usecase.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/update_task_status_usecase.dart';

part 'tasks_state.dart';

/// Which mutating action produced a [TasksActionSuccess] — the UI localizes it.
enum TaskAction { added, updated }

class TasksCubit extends Cubit<TasksState> {
  final GetTasksUseCase _getTasksUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final UpdateTaskStatusUseCase _updateTaskStatusUseCase;
  final UpdateProjectStatusUseCase _updateProjectStatusUseCase;

  TasksCubit(
    this._getTasksUseCase,
    this._createTaskUseCase,
    this._updateTaskStatusUseCase,
    this._updateProjectStatusUseCase,
  ) : super(const TasksInitial());

  late String _projectId;

  Future<void> loadTasks(String projectId) async {
    _projectId = projectId;
    emit(const TasksLoading());
    final result = await _getTasksUseCase(GetTasksParams(projectId));
    result.fold(
      (failure) => emit(TasksError(failure.message)),
      (tasks) => emit(TasksLoaded(tasks)),
    );
  }

  Future<void> createTask({
    required String title,
    required String priority,
  }) async {
    final current = _currentTasks();
    emit(TasksActionInProgress(current));
    final result = await _createTaskUseCase(
      CreateTaskParams(
        projectId: _projectId,
        title: title,
        priority: priority,
      ),
    );
    result.fold(
      (failure) {
        emit(TasksActionFailure(current, failure.message));
        emit(TasksLoaded(current));
      },
      (task) {
        final updated = [task, ...current];
        emit(TasksActionSuccess(updated, TaskAction.added));
        emit(TasksLoaded(updated));
        _syncProjectStatus(updated);
      },
    );
  }

  Future<void> toggleTaskStatus(TaskEntity task) async {
    final current = _currentTasks();
    final newStatus = task.isDone ? TaskStatus.todo : TaskStatus.done;
    emit(TasksActionInProgress(current));
    final result = await _updateTaskStatusUseCase(
      UpdateTaskParams(taskId: task.id, status: newStatus),
    );
    result.fold(
      (failure) {
        emit(TasksActionFailure(current, failure.message));
        emit(TasksLoaded(current));
      },
      (updatedTask) {
        final updated = current
            .map((t) => t.id == updatedTask.id ? updatedTask : t)
            .toList();
        emit(TasksActionSuccess(updated, TaskAction.updated));
        emit(TasksLoaded(updated));
        _syncProjectStatus(updated);
      },
    );
  }

  /// Keeps the project's status in sync with its tasks:
  /// all done → completed, some progress → in_progress, otherwise pending.
  /// Fire-and-forget — a failure here never blocks the task UI.
  Future<void> _syncProjectStatus(List<TaskEntity> tasks) async {
    final status = _deriveProjectStatus(tasks);
    await _updateProjectStatusUseCase(
      UpdateProjectStatusParams(projectId: _projectId, status: status),
    );
  }

  String _deriveProjectStatus(List<TaskEntity> tasks) {
    if (tasks.isEmpty) return ProjectStatus.pending;
    if (tasks.every((t) => t.isDone)) return ProjectStatus.completed;
    if (tasks.any((t) => t.isDone || t.status == TaskStatus.inProgress)) {
      return ProjectStatus.inProgress;
    }
    return ProjectStatus.pending;
  }

  List<TaskEntity> _currentTasks() {
    final state = this.state;
    return state is TasksWithData ? state.tasks : const [];
  }
}
