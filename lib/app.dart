import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart';
import 'core/extensions/build_context_ext.dart';
import 'core/network/supabase_interceptor.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthCubit _authCubit = sl<AuthCubit>();
  late final SettingsCubit _settingsCubit = sl<SettingsCubit>();
  late final AppRouter _appRouter = AppRouter(_authCubit);

  @override
  void initState() {
    super.initState();
    _authCubit.checkAuthStatus();
    _settingsCubit.loadSettings();
    // On a rejected JWT (401), the interceptor clears storage and notifies
    // the AuthCubit so the router redirects to login.
    sl<SupabaseInterceptor>().onUnauthorized = _authCubit.sessionExpired;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider.value(value: _settingsCubit),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            onGenerateTitle: (context) => context.l10n.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            locale: settings.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _appRouter.router,
          );
        },
      ),
    );
  }
}
