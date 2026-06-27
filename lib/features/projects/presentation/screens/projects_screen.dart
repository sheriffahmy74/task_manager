import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../cubit/projects_cubit.dart';
import '../widgets/add_project_bottom_sheet.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectsCubit>()..loadProjects(),
      child: const _ProjectsView(),
    );
  }
}

class _ProjectsView extends StatelessWidget {
  const _ProjectsView();

  void _openAddProjectSheet(BuildContext context) {
    final cubit = context.read<ProjectsCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const AddProjectBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.projects)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddProjectSheet(context),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addProject),
      ),
      body: BlocConsumer<ProjectsCubit, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectsActionSuccess) {
            context.showSuccessSnackbar(context.l10n.projectAdded);
          } else if (state is ProjectsActionFailure) {
            context.showErrorSnackbar(state.message);
          }
        },
        builder: (context, state) {
          return switch (state) {
            ProjectsInitial() || ProjectsLoading() => const AppLoadingWidget(),
            ProjectsError(:final message) => AppErrorWidget(
                message: message,
                onRetry: () => context.read<ProjectsCubit>().loadProjects(),
              ),
            ProjectsWithData(:final projects) => RefreshIndicator(
                onRefresh: () => context.read<ProjectsCubit>().loadProjects(),
                child: projects.isEmpty
                    ? _EmptyList(height: context.screenHeight)
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return ProjectCard(
                            project: project,
                            onTap: () async {
                              await context.push(
                                '/projects/${project.id}',
                                extra: project,
                              );
                              // Refresh on return — project status may have
                              // changed after completing/adding tasks.
                              if (context.mounted) {
                                context.read<ProjectsCubit>().loadProjects();
                              }
                            },
                          );
                        },
                      ),
              ),
          };
        },
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  final double height;

  const _EmptyList({required this.height});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: height * 0.7,
          child: AppEmptyState(
            title: context.l10n.noProjects,
            subtitle: context.l10n.noProjectsSub,
            icon: Icons.folder_open_outlined,
          ),
        ),
      ],
    );
  }
}
