part of 'change_username_bloc.dart';

class ChangeUsernameState extends Equatable {
  const ChangeUsernameState();

  @override
  List<Object> get props => [];
}

class ChangeUsernameInitial extends ChangeUsernameState {}

class ChangeUsernameLoading extends ChangeUsernameState {}

class ChangeUsernameSuccess extends ChangeUsernameState {}

class ChangeUsernameError extends ChangeUsernameState {
  final String errorMessage;

  ChangeUsernameError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
