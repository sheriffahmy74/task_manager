part of 'tasks_cubit.dart';

sealed class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {
  const TasksInitial();
}

class TasksLoading extends TasksState {
  const TasksLoading();
}

class TasksError extends TasksState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Base for states that carry the current task list so the list
/// stays visible during create / status-toggle actions.
sealed class TasksWithData extends TasksState {
  final List<TaskEntity> tasks;

  const TasksWithData(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TasksLoaded extends TasksWithData {
  const TasksLoaded(super.tasks);
}

class TasksActionInProgress extends TasksWithData {
  const TasksActionInProgress(super.tasks);
}

class TasksActionSuccess extends TasksWithData {
  final TaskAction action;

  const TasksActionSuccess(super.tasks, this.action);

  @override
  List<Object?> get props => [tasks, action];
}

class TasksActionFailure extends TasksWithData {
  final String message;

  const TasksActionFailure(super.tasks, this.message);

  @override
  List<Object?> get props => [tasks, message];
}
