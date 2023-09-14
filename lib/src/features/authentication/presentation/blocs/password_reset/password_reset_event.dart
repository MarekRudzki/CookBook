part of 'password_reset_bloc.dart';

class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object> get props => [];
}

class PasswordResetPressed extends PasswordResetEvent {
  final String passwordResetEmail;

  PasswordResetPressed({required this.passwordResetEmail});
  @override
  List<Object> get props => [passwordResetEmail];
}
