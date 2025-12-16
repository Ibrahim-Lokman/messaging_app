/// Base class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.noConnection() {
    return const NetworkException(
      message: 'No internet connection',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Request timeout',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.serverError() {
    return const NetworkException(
      message: 'Server error occurred',
      code: 'SERVER_ERROR',
    );
  }
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthException.invalidCredentials() {
    return const AuthException(
      message: 'Invalid email or password',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthException.userNotFound() {
    return const AuthException(
      message: 'User not found',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthException.emailAlreadyInUse() {
    return const AuthException(
      message: 'Email is already in use',
      code: 'EMAIL_IN_USE',
    );
  }

  factory AuthException.usernameAlreadyTaken() {
    return const AuthException(
      message: 'Username is already taken',
      code: 'USERNAME_TAKEN',
    );
  }

  factory AuthException.weakPassword() {
    return const AuthException(
      message: 'Password is too weak',
      code: 'WEAK_PASSWORD',
    );
  }

  factory AuthException.invalidEmail() {
    return const AuthException(
      message: 'Invalid email format',
      code: 'INVALID_EMAIL',
    );
  }

  factory AuthException.userDisabled() {
    return const AuthException(
      message: 'User account has been disabled',
      code: 'USER_DISABLED',
    );
  }

  factory AuthException.tooManyRequests() {
    return const AuthException(
      message: 'Too many attempts. Please try again later',
      code: 'TOO_MANY_REQUESTS',
    );
  }
}

/// Validation-related exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory ValidationException.emptyField(String fieldName) {
    return ValidationException(
      message: '$fieldName cannot be empty',
      code: 'EMPTY_FIELD',
    );
  }

  factory ValidationException.invalidFormat(String fieldName) {
    return ValidationException(
      message: 'Invalid $fieldName format',
      code: 'INVALID_FORMAT',
    );
  }

  factory ValidationException.tooShort(String fieldName, int minLength) {
    return ValidationException(
      message: '$fieldName must be at least $minLength characters',
      code: 'TOO_SHORT',
    );
  }

  factory ValidationException.tooLong(String fieldName, int maxLength) {
    return ValidationException(
      message: '$fieldName must be at most $maxLength characters',
      code: 'TOO_LONG',
    );
  }
}

/// Server/Backend exceptions
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory ServerException.notFound() {
    return const ServerException(
      message: 'Resource not found',
      code: 'NOT_FOUND',
    );
  }

  factory ServerException.permissionDenied() {
    return const ServerException(
      message: 'Permission denied',
      code: 'PERMISSION_DENIED',
    );
  }

  factory ServerException.unavailable() {
    return const ServerException(
      message: 'Service temporarily unavailable',
      code: 'UNAVAILABLE',
    );
  }
}

/// Cache/Local storage exceptions
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory CacheException.readError() {
    return const CacheException(
      message: 'Failed to read from cache',
      code: 'READ_ERROR',
    );
  }

  factory CacheException.writeError() {
    return const CacheException(
      message: 'Failed to write to cache',
      code: 'WRITE_ERROR',
    );
  }
}
