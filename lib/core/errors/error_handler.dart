import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../errors/app_exception.dart';
import '../errors/failure.dart';

/// Handles conversion of exceptions to failures and provides error mapping
class ErrorHandler {
  /// Convert an exception to a Failure
  static Failure handleException(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return _handleAppException(error);
    } else if (error is FirebaseAuthException) {
      return _handleFirebaseAuthException(error);
    } else if (error is FirebaseException) {
      return _handleFirebaseException(error);
    } else {
      return ServerFailure.unknown(error.toString());
    }
  }

  /// Handle custom app exceptions
  static Failure _handleAppException(AppException exception) {
    if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
      );
    } else if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.code,
      );
    } else {
      return ServerFailure.unknown(exception.message);
    }
  }

  /// Handle Firebase Auth exceptions
  static Failure _handleFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return AuthFailure.userNotFound();
      case 'wrong-password':
        return AuthFailure.invalidCredentials();
      case 'invalid-credential':
        return AuthFailure.invalidCredentials();
      case 'email-already-in-use':
        return AuthFailure.emailAlreadyInUse();
      case 'weak-password':
        return AuthFailure.weakPassword();
      case 'invalid-email':
        return AuthFailure.invalidEmail();
      case 'user-disabled':
        return AuthFailure.userDisabled();
      case 'too-many-requests':
        return AuthFailure.tooManyRequests();
      case 'operation-not-allowed':
        return AuthFailure(
          message: 'This operation is not allowed. Please contact support.',
          code: 'OPERATION_NOT_ALLOWED',
        );
      case 'network-request-failed':
        return NetworkFailure.noConnection();
      default:
        return AuthFailure.unknown(
          exception.message ?? 'An authentication error occurred',
        );
    }
  }

  /// Handle Firebase Firestore exceptions
  static Failure _handleFirebaseException(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return ServerFailure.permissionDenied();
      case 'not-found':
        return ServerFailure.notFound();
      case 'unavailable':
        return ServerFailure.unavailable();
      case 'deadline-exceeded':
        return NetworkFailure.timeout();
      case 'resource-exhausted':
        return ServerFailure(
          message: 'Resource limit exceeded. Please try again later.',
          code: 'RESOURCE_EXHAUSTED',
        );
      case 'unauthenticated':
        return AuthFailure(
          message: 'Authentication required. Please login again.',
          code: 'UNAUTHENTICATED',
        );
      case 'network-request-failed':
      case 'unavailable':
        return NetworkFailure.noConnection();
      default:
        return ServerFailure.unknown(
          exception.message ?? 'A server error occurred',
        );
    }
  }

  /// Get user-friendly error message from Failure
  static String getErrorMessage(Failure failure) {
    return failure.message;
  }

  /// Check if error is retryable
  static bool isRetryable(Failure failure) {
    if (failure is NetworkFailure) {
      return true;
    }
    if (failure is ServerFailure) {
      return failure.code == 'UNAVAILABLE' || failure.code == 'TIMEOUT';
    }
    return false;
  }
}
