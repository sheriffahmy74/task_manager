import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_cached_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/projects/data/datasources/projects_remote_datasource.dart';
import '../../features/projects/data/repositories/projects_repository_impl.dart';
import '../../features/projects/domain/repositories/projects_repository.dart';
import '../../features/projects/domain/usecases/create_project_usecase.dart';
import '../../features/projects/domain/usecases/get_projects_usecase.dart';
import '../../features/projects/domain/usecases/update_project_status_usecase.dart';
import '../../features/projects/presentation/cubit/projects_cubit.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/tasks/data/datasources/tasks_remote_datasource.dart';
import '../../features/tasks/data/repositories/tasks_repository_impl.dart';
import '../../features/tasks/domain/repositories/tasks_repository.dart';
import '../../features/tasks/domain/usecases/create_task_usecase.dart';
import '../../features/tasks/domain/usecases/get_tasks_usecase.dart';
import '../../features/tasks/domain/usecases/update_task_status_usecase.dart';
import '../../features/tasks/presentation/cubit/tasks_cubit.dart';
import '../network/dio_client.dart';
import '../network/network_call_handler.dart';
import '../network/supabase_interceptor.dart';
import '../services/local_storage/local_storage_service.dart';
import '../services/local_storage/secure_storage_impl.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initCore();
  _initSettings();
  _initAuth();
  _initProjects();
  _initTasks();
}

void _initSettings() {
  sl.registerLazySingleton(() => SettingsCubit(sl()));
}

void _initCore() {
  // External
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Services
  sl.registerLazySingleton<LocalStorageService>(
    () => SecureStorageImpl(sl()),
  );

  // Network
  sl.registerLazySingleton<NetworkCallHandler>(() => NetworkCallHandler());

  sl.registerLazySingleton<SupabaseInterceptor>(
    () => SupabaseInterceptor(sl()),
  );

  // Single Dio — apikey on every request (base headers),
  // Bearer token injected by interceptor when a token exists.
  sl.registerLazySingleton<Dio>(
    () => DioClient.create(sl<SupabaseInterceptor>()),
  );
}

void _initAuth() {
  // Datasource
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));

  // Cubit — singleton so the router and widget tree share one instance.
  sl.registerLazySingleton(
    () => AuthCubit(sl(), sl(), sl(), sl()),
  );
}

void _initProjects() {
  // Datasource
  sl.registerLazySingleton<ProjectsRemoteDatasource>(
    () => ProjectsRemoteDatasourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
  sl.registerLazySingleton(() => CreateProjectUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProjectStatusUseCase(sl()));

  // Cubit — factory: a fresh instance per screen.
  sl.registerFactory(() => ProjectsCubit(sl(), sl()));
}

void _initTasks() {
  // Datasource
  sl.registerLazySingleton<TasksRemoteDatasource>(
    () => TasksRemoteDatasourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<TasksRepository>(
    () => TasksRepositoryImpl(sl(), sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => CreateTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskStatusUseCase(sl()));

  // Cubit — factory: a fresh instance per project details screen.
  sl.registerFactory(() => TasksCubit(sl(), sl(), sl(), sl()));
}
