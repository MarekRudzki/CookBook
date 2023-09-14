part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginRegisterMode extends AuthState {
  final bool isLoginMode;

  LoginRegisterMode({required this.isLoginMode});

  @override
  List<Object> get props => [isLoginMode];
}

class UsernameLoaded extends AuthState {
  final String username;

  UsernameLoaded({required this.username});

  @override
  List<Object> get props => [username];
}
