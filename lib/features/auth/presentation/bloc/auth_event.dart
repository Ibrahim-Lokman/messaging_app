import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String identifier; // Can be username or email
  final String password;

  const AuthLoginRequested(this.identifier, this.password);

  @override
  List<Object> get props => [identifier, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const AuthSignUpRequested(this.username, this.email, this.password);

  @override
  List<Object> get props => [username, email, password];
}

class AuthLogoutRequested extends AuthEvent {}

class SignOut extends AuthEvent {}
