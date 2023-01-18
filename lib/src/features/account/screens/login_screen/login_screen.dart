import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../core/constants.dart';
import '../../../main_screen.dart';
import '../../account_provider.dart';
import 'widgets/reset_password.dart';
import 'widgets/register_view.dart';
import 'widgets/login_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AccountProvider _accountProvider = AccountProvider();

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

    await _accountProvider.logIn(
      email: email,
      password: password,
      context: context,
      emailController: _emailController,
      onSuccess: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      },
    );
  }

  Future<void> register(BuildContext context) async {
    final String username = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmedPassword = _confirmedPasswordController.text.trim();

    _accountProvider.register(
      context: context,
      email: email,
      password: password,
      username: username,
      confirmedPassword: confirmedPassword,
      emailController: _emailController,
      onSuccess: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
      backgroundColor: kDarkModeLighter,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            //resizeToAvoidBottomInset: false,
            body: context.select(
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
                    onPasswordResetTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ResetPassword(
                            controller: _passwordResetController,
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
