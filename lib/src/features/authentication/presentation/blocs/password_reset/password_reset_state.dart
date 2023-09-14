part of 'password_reset_bloc.dart';

class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object> get props => [];
}

class PasswordResetInitial extends PasswordResetState {}

class PasswordResetLoading extends PasswordResetState {}

class PasswordResetSuccess extends PasswordResetState {}

class PasswordResetError extends PasswordResetState {
  final String errorMessage;

  PasswordResetError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
