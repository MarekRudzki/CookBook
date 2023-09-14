part of 'register_bloc.dart';

class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterPressed extends RegisterEvent {
  final String email;
  final String password;
  final String username;
  final String confirmedPassword;

  RegisterPressed({
    required this.email,
    required this.password,
    required this.username,
    required this.confirmedPassword,
  });

  @override
  List<Object> get props => [
        email,
        password,
        username,
        confirmedPassword,
      ];
}
