import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/input_validator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              context.showErrorSnackbar(state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.screenHeight * 0.08),
                    Icon(
                      Icons.task_alt_rounded,
                      size: 64,
                      color: context.colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(context.l10n.welcomeBack,
                        style: AppTextStyles.heading1),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.welcomeBackSub,
                      style: AppTextStyles.body.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      label: context.l10n.email,
                      hint: context.l10n.emailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => InputValidator.email(v, context.l10n),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: context.l10n.password,
                      hint: context.l10n.passwordHint,
                      controller: _passwordController,
                      obscureText: _obscure,
                      validator: (v) =>
                          InputValidator.password(v, context.l10n),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      label: context.l10n.login,
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.l10n.noAccount),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.register),
                          child: Text(
                            context.l10n.register,
                            style: AppTextStyles.subtitle.copyWith(
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
