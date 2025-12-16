import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String uid;

  const AuthAuthenticated(this.uid);

  @override
  List<Object?> get props => [uid];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final Failure failure;
  final bool canRetry;

  const AuthError(this.failure, {this.canRetry = false});

  String get message => failure.message;

  @override
  List<Object?> get props => [failure, canRetry];
}
