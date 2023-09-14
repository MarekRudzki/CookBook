part of 'change_password_bloc.dart';

class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordPressed extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmedNewPassword;

  ChangePasswordPressed({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmedNewPassword,
  });

  @override
  List<Object> get props => [
        currentPassword,
        newPassword,
        confirmedNewPassword,
      ];
}
