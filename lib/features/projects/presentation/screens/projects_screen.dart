import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/projects_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.projects),
        actions: [
          // Temporary — moved to the Profile tab in Phase 10.
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: BlocBuilder<ProjectsCubit, ProjectsState>(
        builder: (context, state) {
          return switch (state) {
            ProjectsInitial() ||
            ProjectsLoading() =>
              const AppLoadingWidget(),
            ProjectsError(:final message) => AppErrorWidget(
                message: message,
                onRetry: () => context.read<ProjectsCubit>().loadProjects(),
              ),
            ProjectsLoaded(:final projects) => RefreshIndicator(
                onRefresh: () =>
                    context.read<ProjectsCubit>().loadProjects(),
                child: projects.isEmpty
                    ? _EmptyList(height: context.screenHeight)
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return ProjectCard(
                            project: project,
                            onTap: () => context.push(
                              '/projects/${project.id}',
                              extra: project,
                            ),
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
          child: const AppEmptyState(
            title: AppStrings.noProjects,
            subtitle: AppStrings.noProjectsSub,
            icon: Icons.folder_open_outlined,
          ),
        ),
      ],
    );
  }
}
