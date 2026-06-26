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
import '../../features/projects/domain/usecases/get_projects_usecase.dart';
import '../../features/projects/presentation/cubit/projects_cubit.dart';
import '../network/dio_client.dart';
import '../network/network_call_handler.dart';
import '../network/supabase_interceptor.dart';
import '../services/local_storage/local_storage_service.dart';
import '../services/local_storage/secure_storage_impl.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initCore();
  _initAuth();
  _initProjects();
  // _initTasks();     (Phase 9)
  // _initProfile();   (Phase 10)
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

  // Use case
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));

  // Cubit — factory: a fresh instance per screen.
  sl.registerFactory(() => ProjectsCubit(sl()));
}
