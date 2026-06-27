import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final ValueChanged<bool?> onToggleDone;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleDone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: task.isDone,
              onChanged: onToggleDone,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppTextStyles.subtitle.copyWith(
                        decoration: task.isDone
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isDone
                            ? context.colorScheme.onSurfaceVariant
                            : null,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        StatusBadge(status: task.status),
                        const SizedBox(width: 8),
                        _PriorityChip(priority: task.priority),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final String priority;

  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = switch (priority.toLowerCase()) {
      'high' => AppColors.priorityHigh,
      'low' => AppColors.priorityLow,
      _ => AppColors.priorityMedium,
    };
    final label = switch (priority.toLowerCase()) {
      'high' => context.l10n.priorityHigh,
      'low' => context.l10n.priorityLow,
      _ => context.l10n.priorityMedium,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.flag_rounded, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
