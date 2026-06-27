import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/input_validator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/task_entity.dart';
import '../cubit/tasks_cubit.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _priority = TaskPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<TasksCubit>().createTask(
            title: _titleController.text.trim(),
            priority: _priority,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {
          if (state is TasksActionSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final isSubmitting = state is TasksActionInProgress;
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(context.l10n.addTask, style: AppTextStyles.heading2),
                const SizedBox(height: 20),
                AppTextField(
                  label: context.l10n.taskTitle,
                  hint: context.l10n.taskTitleHint,
                  controller: _titleController,
                  validator: (v) => InputValidator.required(v, context.l10n),
                ),
                const SizedBox(height: 20),
                Text(
                  context.l10n.priority,
                  style: context.textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                        value: TaskPriority.low,
                        label: Text(context.l10n.priorityLow)),
                    ButtonSegment(
                        value: TaskPriority.medium,
                        label: Text(context.l10n.priorityMedium)),
                    ButtonSegment(
                        value: TaskPriority.high,
                        label: Text(context.l10n.priorityHigh)),
                  ],
                  selected: {_priority},
                  onSelectionChanged: (selection) {
                    setState(() => _priority = selection.first);
                  },
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: context.l10n.submit,
                  isLoading: isSubmitting,
                  onPressed: _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
