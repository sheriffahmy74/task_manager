import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bg, label) = _resolve(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Maps raw status values (task_status enum + project statuses)
  /// to a colour pair and a human-readable label.
  (Color, Color, String) _resolve(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return (AppColors.done, AppColors.doneBg, 'Done');
      case 'completed':
        return (AppColors.done, AppColors.doneBg, 'Completed');
      case 'in_progress':
      case 'in progress':
        return (AppColors.inProgress, AppColors.inProgressBg, 'In Progress');
      case 'active':
        return (AppColors.inProgress, AppColors.inProgressBg, 'Active');
      case 'todo':
        return (AppColors.pending, AppColors.pendingBg, 'To Do');
      case 'pending':
        return (AppColors.pending, AppColors.pendingBg, 'Pending');
      case 'on_hold':
        return (AppColors.pending, AppColors.pendingBg, 'On Hold');
      default:
        return (AppColors.pending, AppColors.pendingBg, status);
    }
  }
}
