import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure: $message${code != null ? ' (code: $code)' : ''}';
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });

  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      message: 'No internet connection. Please check your network settings.',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'Connection timeout. Please try again.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkFailure.serverError() {
    return const NetworkFailure(
      message: 'Server error. Please try again later.',
      code: 'SERVER_ERROR',
    );
  }
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });

  factory AuthFailure.invalidCredentials() {
    return const AuthFailure(
      message: 'Invalid username/email or password. Please try again.',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthFailure.userNotFound() {
    return const AuthFailure(
      message: 'No account found with this username/email.',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthFailure.emailAlreadyInUse() {
    return const AuthFailure(
      message: 'This email is already registered. Please login instead.',
      code: 'EMAIL_IN_USE',
    );
  }

  factory AuthFailure.usernameAlreadyTaken() {
    return const AuthFailure(
      message: 'This username is already taken. Please choose another.',
      code: 'USERNAME_TAKEN',
    );
  }

  factory AuthFailure.weakPassword() {
    return const AuthFailure(
      message: 'Password is too weak. Please use a stronger password.',
      code: 'WEAK_PASSWORD',
    );
  }

  factory AuthFailure.invalidEmail() {
    return const AuthFailure(
      message: 'Invalid email format. Please check and try again.',
      code: 'INVALID_EMAIL',
    );
  }

  factory AuthFailure.userDisabled() {
    return const AuthFailure(
      message: 'Your account has been disabled. Please contact support.',
      code: 'USER_DISABLED',
    );
  }

  factory AuthFailure.tooManyRequests() {
    return const AuthFailure(
      message: 'Too many login attempts. Please try again later.',
      code: 'TOO_MANY_REQUESTS',
    );
  }

  factory AuthFailure.unknown(String message) {
    return AuthFailure(
      message: message,
      code: 'UNKNOWN',
    );
  }
}

/// Validation-related failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Server/Backend failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });

  factory ServerFailure.notFound() {
    return const ServerFailure(
      message: 'Resource not found.',
      code: 'NOT_FOUND',
    );
  }

  factory ServerFailure.permissionDenied() {
    return const ServerFailure(
      message: 'You don\'t have permission to perform this action.',
      code: 'PERMISSION_DENIED',
    );
  }

  factory ServerFailure.unavailable() {
    return const ServerFailure(
      message: 'Service temporarily unavailable. Please try again later.',
      code: 'UNAVAILABLE',
    );
  }

  factory ServerFailure.unknown(String message) {
    return ServerFailure(
      message: message,
      code: 'UNKNOWN',
    );
  }
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}
