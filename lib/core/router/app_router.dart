import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_shell.dart';
import '../../features/projects/domain/entities/project_entity.dart';
import '../../features/tasks/presentation/screens/project_details_screen.dart';
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
        builder: (context, state) => const HomeShell(),
      ),
      GoRoute(
        path: AppRoutes.projectDetails,
        builder: (context, state) {
          final project = state.extra as ProjectEntity?;
          if (project == null) {
            return const _MissingProject();
          }
          return ProjectDetailsScreen(project: project);
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

/// Shown if the details route is opened without a project (e.g. deep link).
class _MissingProject extends StatelessWidget {
  const _MissingProject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Project not found')),
    );
  }
}
