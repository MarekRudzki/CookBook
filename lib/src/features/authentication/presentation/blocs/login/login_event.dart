part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LogInPressed extends LoginEvent {
  final String email;
  final String password;

  LogInPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
