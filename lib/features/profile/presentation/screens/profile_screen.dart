import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/build_context_ext.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.logout),
        content: Text(context.l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      context.read<AuthCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profile)),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state is Authenticated ? state.user : null;
          final name = user?.name ?? '';
          final email = user?.email ?? '';
          final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 16),
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: context.colorScheme.primaryContainer,
                  child: Text(
                    initial,
                    style: AppTextStyles.heading1.copyWith(
                      color: context.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  name.isEmpty ? context.l10n.profile : name,
                  style: AppTextStyles.heading2,
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  email,
                  style: AppTextStyles.body.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _InfoTile(
                icon: Icons.person_outline,
                label: context.l10n.fullName,
                value: name,
              ),
              const SizedBox(height: 12),
              _InfoTile(
                icon: Icons.email_outlined,
                label: context.l10n.email,
                value: email,
              ),
              const SizedBox(height: 28),
              const _SettingsSection(),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: Icon(Icons.logout, color: context.colorScheme.error),
                label: Text(
                  context.l10n.logout,
                  style: TextStyle(color: context.colorScheme.error),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  side: BorderSide(color: context.colorScheme.error),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel(label: context.l10n.appearance),
            const SizedBox(height: 8),
            SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.brightness_auto, size: 18),
                  label: Text(context.l10n.themeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode, size: 18),
                  label: Text(context.l10n.themeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode, size: 18),
                  label: Text(context.l10n.themeDark),
                ),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (selection) =>
                  context.read<SettingsCubit>().setThemeMode(selection.first),
            ),
            const SizedBox(height: 24),
            _SectionLabel(label: context.l10n.language),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 'en', label: Text('English')),
                ButtonSegment(value: 'ar', label: Text('العربية')),
              ],
              selected: {settings.locale.languageCode},
              onSelectionChanged: (selection) => context
                  .read<SettingsCubit>()
                  .setLocale(Locale(selection.first)),
            ),
          ],
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.label.copyWith(
        color: context.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.4,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: context.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
