part of 'login_cubit.dart';

class LoginState {
  LoginState({
    this.isCreatingAccount = false,
    this.isLoading = false,
    this.errorMessage = '',
  });

  final bool isCreatingAccount;
  final bool isLoading;
  final String errorMessage;
}
