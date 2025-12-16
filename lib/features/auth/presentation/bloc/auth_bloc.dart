import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/notification_service.dart';
import '../../../../core/errors/error_handler.dart';
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
      final result;
      
      // Detect if identifier is email or username
      if (event.identifier.contains('@')) {
        // It's an email
        result = await authRepository.login(
          email: event.identifier,
          password: event.password,
        );
      } else {
        // It's a username
        result = await authRepository.loginWithUsername(
          username: event.identifier,
          password: event.password,
        );
      }
      
      result.fold(
        onSuccess: (uid) async {
          emit(AuthAuthenticated(uid));
          
          // Try to save token
          try {
            await notificationService.saveToken(uid);
          } catch (_) {
            // Ignore notification token errors
          }
        },
        onFailure: (failure) {
          emit(AuthError(
            failure,
            canRetry: ErrorHandler.isRetryable(failure),
          ));
        },
      );
      
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      emit(AuthError(failure, canRetry: ErrorHandler.isRetryable(failure)));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.signup(
        username: event.username,
        email: event.email,
        password: event.password,
      );
      
      result.fold(
        onSuccess: (uid) async {
          emit(AuthAuthenticated(uid));
          
          // Try to save token
          try {
            await notificationService.saveToken(uid);
          } catch (_) {
            // Ignore notification token errors
          }
        },
        onFailure: (failure) {
          emit(AuthError(
            failure,
            canRetry: ErrorHandler.isRetryable(failure),
          ));
        },
      );
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      emit(AuthError(failure, canRetry: ErrorHandler.isRetryable(failure)));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.logout();
      
      result.fold(
        onSuccess: (_) {
          emit(AuthUnauthenticated());
        },
        onFailure: (failure) {
          emit(AuthError(failure));
        },
      );
    } catch (e, stackTrace) {
      final failure = ErrorHandler.handleException(e, stackTrace);
      emit(AuthError(failure));
    }
  }
}
