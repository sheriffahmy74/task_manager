import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/projects/domain/entities/project_entity.dart';
import '../../features/projects/presentation/screens/projects_screen.dart';
import '../widgets/app_loading_widget.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String projects = '/projects';
  static const String projectDetails = '/projects/:id';
  static const String profile = '/profile';
}

/// Bridges a [Stream] (a Cubit's state stream) to a [Listenable]
/// so GoRouter re-runs its redirect logic on auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.projects,
        builder: (context, state) => const ProjectsScreen(),
      ),
      GoRoute(
        path: AppRoutes.projectDetails,
        builder: (context, state) {
          final project = state.extra as ProjectEntity?;
          return _ProjectDetailsPlaceholder(project: project);
        },
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final authState = authCubit.state;
    final loc = state.matchedLocation;

    // Still resolving the cached session on startup.
    if (authState is AuthInitial) {
      return loc == AppRoutes.splash ? null : AppRoutes.splash;
    }

    final isAuthed = authState is Authenticated;
    final onAuthScreen =
        loc == AppRoutes.login || loc == AppRoutes.register;
    final onSplash = loc == AppRoutes.splash;

    if (!isAuthed) {
      return onAuthScreen ? null : AppRoutes.login;
    }

    // Authenticated — keep users out of auth/splash screens.
    if (onAuthScreen || onSplash) return AppRoutes.projects;
    return null;
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AppLoadingWidget());
  }
}

/// Temporary — replaced by the real Project Details screen in Phase 9.
class _ProjectDetailsPlaceholder extends StatelessWidget {
  final ProjectEntity? project;

  const _ProjectDetailsPlaceholder({this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project?.title ?? 'Project')),
      body: Center(
        child: Text('Tasks for "${project?.title ?? ''}" — coming in Phase 9'),
      ),
    );
  }
}
