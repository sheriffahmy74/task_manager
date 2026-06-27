import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../extensions/build_context_ext.dart';
import '../theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bg, label) = _resolve(status, context.l10n);
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
  /// to a colour pair and a localized label.
  (Color, Color, String) _resolve(String status, AppLocalizations l10n) {
    switch (status.toLowerCase()) {
      case 'done':
        return (AppColors.done, AppColors.doneBg, l10n.statusDone);
      case 'completed':
        return (AppColors.done, AppColors.doneBg, l10n.statusCompleted);
      case 'in_progress':
      case 'in progress':
        return (AppColors.inProgress, AppColors.inProgressBg,
            l10n.statusInProgress);
      case 'active':
        return (AppColors.inProgress, AppColors.inProgressBg,
            l10n.statusActive);
      case 'todo':
      case 'to_do':
        return (AppColors.pending, AppColors.pendingBg, l10n.statusToDo);
      case 'pending':
        return (AppColors.pending, AppColors.pendingBg, l10n.statusPending);
      case 'on_hold':
        return (AppColors.pending, AppColors.pendingBg, l10n.statusOnHold);
      default:
        return (AppColors.pending, AppColors.pendingBg, status);
    }
  }
}
