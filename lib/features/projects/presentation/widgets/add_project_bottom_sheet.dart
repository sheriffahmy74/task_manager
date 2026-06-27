import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/input_validator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/projects_cubit.dart';

class AddProjectBottomSheet extends StatefulWidget {
  const AddProjectBottomSheet({super.key});

  @override
  State<AddProjectBottomSheet> createState() => _AddProjectBottomSheetState();
}

class _AddProjectBottomSheetState extends State<AddProjectBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProjectsCubit>().createProject(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
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
      child: BlocConsumer<ProjectsCubit, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectsActionSuccess) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final isSubmitting = state is ProjectsActionInProgress;
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
                Text(context.l10n.addProject, style: AppTextStyles.heading2),
                const SizedBox(height: 20),
                AppTextField(
                  label: context.l10n.projectName,
                  hint: context.l10n.projectNameHint,
                  controller: _nameController,
                  validator: (v) => InputValidator.required(v, context.l10n),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: context.l10n.description,
                  hint: context.l10n.descriptionHint,
                  controller: _descriptionController,
                  maxLines: 3,
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
