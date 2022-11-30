part of 'login_screen_cubit.dart';

class LoginScreenState {
  LoginScreenState({
    required this.email,
    required this.password,
    required this.isCreatingAccount,
    required this.isLoading,
  });

  final String email;
  final String password;
  final bool isCreatingAccount;
  final bool isLoading;
}
