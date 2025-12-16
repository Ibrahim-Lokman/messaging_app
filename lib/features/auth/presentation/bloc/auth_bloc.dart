import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/notification_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final NotificationService notificationService;

  AuthBloc({
    required this.authRepository, 
    required this.notificationService,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final uid = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      
      emit(AuthAuthenticated(uid));
      
      // Try to save token
      try {
         await notificationService.saveToken(uid);
      } catch (_) {}
      
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  
  // ... (rest of methods)

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final uid = await authRepository.signup(
        username: event.username,
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(uid));
      try {
         await notificationService.saveToken(uid);
      } catch (_) {}
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
