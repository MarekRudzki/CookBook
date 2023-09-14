part of 'logout_bloc.dart';

class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutError extends LogoutState {
  final String errorMessage;

  LogoutError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
