import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../../domain/entities/task_entity.dart';
import '../cubit/tasks_cubit.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/task_card.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final ProjectEntity project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TasksCubit>()..loadTasks(project.id),
      child: _ProjectDetailsView(project: project),
    );
  }
}

class _ProjectDetailsView extends StatelessWidget {
  final ProjectEntity project;

  const _ProjectDetailsView({required this.project});

  void _openAddTaskSheet(BuildContext context) {
    final cubit = context.read<TasksCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const AddTaskBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTaskSheet(context),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addTask),
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is TasksActionSuccess) {
            context.showSuccessSnackbar(
              state.action == TaskAction.added
                  ? context.l10n.taskAdded
                  : context.l10n.taskUpdated,
            );
          } else if (state is TasksActionFailure) {
            context.showErrorSnackbar(state.message);
          }
        },
        builder: (context, state) {
          return switch (state) {
            TasksInitial() || TasksLoading() => const AppLoadingWidget(),
            TasksError(:final message) => AppErrorWidget(
                message: message,
                onRetry: () =>
                    context.read<TasksCubit>().loadTasks(project.id),
              ),
            TasksWithData(:final tasks) => _TasksList(
                project: project,
                tasks: tasks,
              ),
          };
        },
      ),
    );
  }
}

class _TasksList extends StatelessWidget {
  final ProjectEntity project;
  final List<TaskEntity> tasks;

  const _TasksList({required this.project, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<TasksCubit>().loadTasks(project.id),
      child: tasks.isEmpty
          ? _EmptyTasks(height: context.screenHeight)
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                if (project.description.isNotEmpty) ...[
                  Text(project.description, style: AppTextStyles.body),
                  const SizedBox(height: 16),
                ],
                Text(
                  context.l10n.tasksCount(tasks.length),
                  style: AppTextStyles.label.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                ...tasks.map(
                  (task) => TaskCard(
                    task: task,
                    onToggleDone: (_) =>
                        context.read<TasksCubit>().toggleTaskStatus(task),
                  ),
                ),
              ],
            ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  final double height;

  const _EmptyTasks({required this.height});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: height * 0.7,
          child: AppEmptyState(
            title: context.l10n.noTasks,
            subtitle: context.l10n.noTasksSub,
            icon: Icons.checklist_rounded,
          ),
        ),
      ],
    );
  }
}
