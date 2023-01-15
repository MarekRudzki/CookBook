import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../services/firebase/firestore.dart';
import '../../../../services/hive_services.dart';
import '../../../../services/firebase/auth.dart';
import '../../../common_widgets/error_handling.dart';
import '../../../main_screen.dart';
import '../../account_provider.dart';
import 'widgets/reset_password.dart';
import 'widgets/register_view.dart';
import 'widgets/login_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Auth _auth = Auth();
  final Firestore _firestore = Firestore();
  final ErrorHandling _errorHandling = ErrorHandling();
  final HiveServices _hiveServices = HiveServices();

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

    _errorHandling.toggleLoadingSpinner(context);
    await _auth
        .logIn(
      email: email,
      password: password,
    )
        .then(
      (errorText) {
        _errorHandling.toggleLoadingSpinner(context);
        FocusManager.instance.primaryFocus?.unfocus();
        if (errorText.isNotEmpty) {
          _errorHandling.showInfoSnackbar(context, errorText);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
          _hiveServices.setUserEmail(_emailController.text);
        }
      },
    );
  }

  Future<void> register(BuildContext context) async {
    final String username = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmedPassword = _confirmedPasswordController.text.trim();

    _errorHandling.toggleLoadingSpinner(context);
    await _auth
        .register(
      email: email,
      password: password,
      username: username,
      confirmedPassword: confirmedPassword,
    )
        .then(
      (errorText) {
        _errorHandling.toggleLoadingSpinner(context);
        FocusManager.instance.primaryFocus?.unfocus();
        if (errorText.isNotEmpty) {
          _errorHandling.showInfoSnackbar(context, errorText);
        } else {
          _firestore.addUser(username).then(
                (errorText) => {
                  if (errorText.isNotEmpty)
                    {
                      _errorHandling.showInfoSnackbar(context, errorText),
                    }
                  else
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      ),
                      _hiveServices.setUserEmail(_emailController.text),
                      _hiveServices.setUsername(username: username),
                    }
                },
              );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_login.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: context.select(
                  (AccountProvider provider) => provider.isCreatingAccount)
              ? RegisterView(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  nameController: _nameController,
                  confirmedPasswordController: _confirmedPasswordController,
                  onRegisterTap: () => register(context),
                  onLoginTap: () {
                    accountProvider.switchLoginRegister();
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
                    accountProvider.switchLoginRegister();
                    _emailController.clear();
                    _passwordController.clear();
                  },
                  onPasswordResetTap: () => resetPassword(
                    context,
                    _passwordResetController,
                  ),
                ),
        ),
      ),
    );
  }
}
