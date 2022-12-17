import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/shared_prefs.dart';
import '../../../services/firebase/auth.dart';
import '../../../services/firebase/firestore.dart';
import '../../common_widgets/error_handling.dart';
import '../../main_screen.dart';
import '../cubit/account_cubit.dart';
import '../widgets/login_view.dart';
import '../widgets/register_view.dart';
import '../widgets/reset_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth _auth = Auth();
  final Firestore _firestore = Firestore();
  final SharedPrefs _sharedPrefs = SharedPrefs();
  final ErrorHandling _errorHandling = ErrorHandling();

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

  Future<void> logIn(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    _errorHandling.loadingSpinner(context);
    await _auth
        .logIn(
      email: email,
      password: password,
    )
        .then((errorText) {
      _errorHandling.loadingSpinner(context);
      FocusManager.instance.primaryFocus?.unfocus();
      if (errorText.isNotEmpty) {
        _errorHandling.showErrorSnackbar(context, errorText);
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

  Future<void> register(BuildContext context, AccountCubit accountCubit) async {
    final String username = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmedPassword = _confirmedPasswordController.text.trim();

    _errorHandling.loadingSpinner(context);
    await _auth
        .register(
      email: email,
      password: password,
      username: username,
      confirmedPassword: confirmedPassword,
    )
        .then((errorText) {
      _errorHandling.loadingSpinner(context);
      FocusManager.instance.primaryFocus?.unfocus();
      if (errorText.isNotEmpty) {
        _errorHandling.showErrorSnackbar(context, errorText);
      } else {
        _firestore.addUser(username, _auth.uid!).then((errorText) => {
              if (errorText.isNotEmpty)
                {
                  _errorHandling.showErrorSnackbar(context, errorText),
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
          loadingSpinner: _errorHandling.loadingSpinner,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountCubit = BlocProvider.of<AccountCubit>(context);
    return BlocBuilder<AccountCubit, AccountState>(
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
              child: accountCubit.state.isCreatingAccount
                  ? RegisterView(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      nameController: _nameController,
                      confirmedPasswordController: _confirmedPasswordController,
                      onRegisterTap: () => register(context, accountCubit),
                      onLoginTap: () {
                        accountCubit.switchLoginRegister();
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
                        accountCubit.switchLoginRegister();
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
