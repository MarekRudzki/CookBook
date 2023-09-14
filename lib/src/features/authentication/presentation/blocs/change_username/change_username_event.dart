part of 'change_username_bloc.dart';

class ChangeUsernameEvent extends Equatable {
  const ChangeUsernameEvent();

  @override
  List<Object> get props => [];
}

class ChangeUsernamePressed extends ChangeUsernameEvent {
  final String newUsername;

  ChangeUsernamePressed({required this.newUsername});

  @override
  List<Object> get props => [newUsername];
}
