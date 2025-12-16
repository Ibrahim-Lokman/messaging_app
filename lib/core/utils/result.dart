import 'package:equatable/equatable.dart';
import '../errors/failure.dart';

/// A Result type for functional error handling
/// Either contains a success value of type T or a Failure
sealed class Result<T> extends Equatable {
  const Result();

  /// Check if this result is a success
  bool get isSuccess => this is Success<T>;

  /// Check if this result is a failure
  bool get isFailure => this is Failure;

  /// Get the value if success, otherwise null
  T? getOrNull() {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    return null;
  }

  /// Get the failure if this is a failure, otherwise null
  Failure? getFailureOrNull() {
    if (this is ResultFailure<T>) {
      return (this as ResultFailure<T>).failure;
    }
    return null;
  }

  /// Fold the result into a single value
  /// Calls [onSuccess] if this is a success, [onFailure] if this is a failure
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    } else {
      return onFailure((this as ResultFailure<T>).failure);
    }
  }

  /// Map the success value to a new type
  Result<R> map<R>(R Function(T value) transform) {
    if (this is Success<T>) {
      return Success(transform((this as Success<T>).value));
    } else {
      return ResultFailure((this as ResultFailure<T>).failure);
    }
  }

  /// Chain another Result-returning operation
  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    if (this is Success<T>) {
      return transform((this as Success<T>).value);
    } else {
      return ResultFailure((this as ResultFailure<T>).failure);
    }
  }

  @override
  List<Object?> get props => [];
}

/// Success result containing a value
class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'Success($value)';
}

/// Failure result containing a Failure
class ResultFailure<T> extends Result<T> {
  final Failure failure;

  const ResultFailure(this.failure);

  @override
  List<Object?> get props => [failure];

  @override
  String toString() => 'ResultFailure($failure)';
}
