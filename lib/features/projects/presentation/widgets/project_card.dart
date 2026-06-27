import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/project_entity.dart';

class ProjectCard extends StatelessWidget {
  final ProjectEntity project;
  final VoidCallback onTap;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: AppTextStyles.heading3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(status: project.status),
                ],
              ),
              if (project.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: AppTextStyles.body.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: context.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.viewTasks,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
