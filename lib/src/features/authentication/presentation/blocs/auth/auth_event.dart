part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRegisterSwitched extends AuthEvent {
  final bool isLoginMode;

  LoginRegisterSwitched({required this.isLoginMode});

  @override
  List<Object> get props => [isLoginMode];
}

class UsernameRequested extends AuthEvent {}
