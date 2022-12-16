import 'package:cookbook/src/services/firebase/firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../login/cubit/login_screen_cubit.dart';
import '../login/widgets/register_view.dart';
import '../main/main_screen.dart';
import 'widgets/login_view.dart';
import '../../../../src/services/shared_prefs.dart';
import '../../../../src/services/firebase/auth.dart';

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
      if (errorText.isNotEmpty) {
        loadingSpinner(context);
        showErrorDialog(context, errorText);

        FocusManager.instance.primaryFocus?.unfocus();
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
      if (errorText.isNotEmpty) {
        loadingSpinner(context);
        showErrorDialog(context, errorText);
        FocusManager.instance.primaryFocus?.unfocus();
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
    final loginCubit = BlocProvider.of<LoginScreenCubit>(context);
    //TODO handle password reset
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Reset your password?',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Enter the email adress associated with your account',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: kLighterBlue,
          actions: [
            Column(
              children: [
                TextField(
                  controller: _passwordResetController,
                  decoration: InputDecoration(
                    label: const Center(
                      child: Text('Input your email'),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white70),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<LoginScreenCubit, LoginScreenState>(
                    builder: (context, state) {
                      return state.errorMessage != ''
                          ? Text(
                              state.errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        String errorMsg = '';
                        if (_passwordResetController.text.trim().isEmpty) {
                          errorMsg = 'Field is empty';
                          loginCubit.addErrorMessage(errorMsg);
                          await Future.delayed(
                            const Duration(seconds: 3),
                          );
                          loginCubit.addErrorMessage('');
                          return;
                        }
                        try {
                          loadingSpinner(context);
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: _passwordResetController.text.trim(),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-email') {
                            errorMsg = 'Email adress is not valid';
                          } else if (e.code == 'user-not-found') {
                            errorMsg = 'User not found';
                          } else {
                            errorMsg = 'Unknown error';
                          }
                          return;
                        } finally {
                          loadingSpinner(context);
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (errorMsg != '') {
                            loginCubit.addErrorMessage(errorMsg);
                            await Future.delayed(
                              const Duration(seconds: 3),
                            );
                            loginCubit.addErrorMessage('');
                          }
                        }
                        if (!mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Check your mailbox',
                                style: TextStyle(color: Colors.white70),
                              ),
                              content: const Text(
                                'You should find link to reset your password in your mailbox.',
                                style: TextStyle(color: Colors.white70),
                              ),
                              backgroundColor: kLighterBlue,
                              actions: [
                                Center(
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _passwordResetController.clear();
                        loginCubit.addErrorMessage('');
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
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
