part of 'login_screen_cubit.dart';

class LoginScreenState {
  LoginScreenState({
    required this.email,
    required this.password,
    this.isCreatingAccount = false,
    this.isLoading = false,
  });

  final String email;
  final String password;
  final bool isCreatingAccount;
  final bool isLoading;
}
