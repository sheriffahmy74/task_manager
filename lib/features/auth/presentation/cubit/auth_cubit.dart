import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_cached_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCachedUserUseCase _getCachedUserUseCase;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getCachedUserUseCase,
  ) : super(const AuthInitial());

  /// Called on app start — auto-login if a valid cached session exists.
  Future<void> checkAuthStatus() async {
    final result = await _getCachedUserUseCase(const NoParams());
    result.fold(
      (_) => emit(const Unauthenticated()),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> register(String name, String email, String password) async {
    emit(const AuthLoading());
    final result = await _registerUseCase(
      RegisterParams(name: name, email: email, password: password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const RegisterSuccess()),
    );
  }

  Future<void> logout() async {
    await _logoutUseCase(const NoParams());
    emit(const Unauthenticated());
  }

  /// Called by the network layer when the JWT is rejected (401).
  /// Storage is already cleared by the interceptor — just flip the state
  /// so GoRouter redirects to login.
  void sessionExpired() {
    if (state is! Unauthenticated) {
      emit(const Unauthenticated());
    }
  }
}
