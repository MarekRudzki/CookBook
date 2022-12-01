part of 'login_screen_cubit.dart';

class LoginScreenState {
  LoginScreenState({
    this.email = '',
    this.password = '',
    this.isCreatingAccount = false,
    this.isLoading = false,
    this.errorMessage = '',
  });

  final String email;
  final String password;
  final bool isCreatingAccount;
  final bool isLoading;
  final String errorMessage;
}
