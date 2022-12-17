import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../src/services/shared_prefs.dart';
import '../../../../src/services/firebase/auth.dart';
import '../../../../src/services/firebase/firestore.dart';
import '../main/main_screen.dart';
import 'cubit/login_screen_cubit.dart';
import 'widgets/register_view.dart';
import 'widgets/reset_password.dart';
import 'widgets/login_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth _auth = Auth();
  final Firestore _firestore = Firestore();
  final SharedPrefs _sharedPrefs = SharedPrefs();

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmedPasswordController = TextEditingController();

  final _passwordResetController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
    _passwordResetController.dispose();
  }

  void showErrorDialog(BuildContext context, String errorText) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorText, textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  void loadingSpinner(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginScreenCubit>(context);
    loginCubit.switchLoading();
    loginCubit.state.isLoading
        ? showDialog(
            context: context,
            builder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
          )
        : Navigator.of(context).pop();
  }

  Future<void> logIn(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    loadingSpinner(context);
    await _auth
        .logIn(
      email: email,
      password: password,
    )
        .then((errorText) {
      loadingSpinner(context);
      FocusManager.instance.primaryFocus?.unfocus();
      if (errorText.isNotEmpty) {
        showErrorDialog(context, errorText);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
        _sharedPrefs.setUser(_emailController.text);
      }
    });
  }

  Future<void> register(
      BuildContext context, LoginScreenCubit loginCubit) async {
    final String username = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmedPassword = _confirmedPasswordController.text.trim();

    loadingSpinner(context);
    await _auth
        .register(
      email: email,
      password: password,
      username: username,
      confirmedPassword: confirmedPassword,
    )
        .then((errorText) {
      loadingSpinner(context);
      FocusManager.instance.primaryFocus?.unfocus();
      if (errorText.isNotEmpty) {
        showErrorDialog(context, errorText);
      } else {
        _firestore.addUser(username, _auth.uid!).then((errorText) => {
              if (errorText.isNotEmpty)
                {
                  showErrorDialog(context, errorText),
                }
              else
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                  ),
                  _sharedPrefs.setUser(_emailController.text),
                }
            });
      }
    });
  }

  void resetPassword(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ResetPassword(
          passwordResetController: _passwordResetController,
          loadingSpinner: loadingSpinner,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginScreenCubit>(context);
    return BlocBuilder<LoginScreenCubit, LoginScreenState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background_login.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: loginCubit.state.isCreatingAccount
                  ? RegisterView(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      nameController: _nameController,
                      confirmedPasswordController: _confirmedPasswordController,
                      onRegisterTap: () => register(context, loginCubit),
                      onLoginTap: () {
                        loginCubit.switchLoginRegister();
                        _emailController.clear();
                        _passwordController.clear();
                        _confirmedPasswordController.clear();
                        _nameController.clear();
                      },
                    )
                  : LoginView(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      onLoginTap: () => logIn(context),
                      onRegisterTap: () {
                        loginCubit.switchLoginRegister();
                        _emailController.clear();
                        _passwordController.clear();
                      },
                      onPswResetTap: () => resetPassword(context),
                    ),
            ),
          ),
        );
      },
    );
  }
}
