part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String errorMessage;

  RegisterError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
