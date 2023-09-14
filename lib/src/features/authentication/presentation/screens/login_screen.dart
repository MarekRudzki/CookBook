import 'package:cookbook/src/features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/login/login_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/register/register_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/login_screen/login_view.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/login_screen/register_view.dart';
import 'package:cookbook/src/features/authentication/presentation/widgets/login_screen/reset_password.dart';
import 'package:cookbook/src/features/common_widgets/custom_snackbar.dart';
import 'package:cookbook/src/features/common_widgets/on_will_pop_alert_dialog.dart';
import 'package:cookbook/src/features/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(LoginRegisterSwitched(isLoginMode: true));

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: WillPopScope(
          onWillPop: () async {
            final bool? exitResult = await showDialog(
                context: context,
                builder: (context) => const OnWillPopAlertDialog());
            return exitResult ?? false;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is LoginRegisterMode) {
                  if (state.isLoginMode) {
                    return BlocConsumer<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginError) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(CustomSnackbar.showSnackBar(
                            message: state.errorMessage,
                          ));
                        } else if (state is LoginSuccess) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return LoginView(
                          state: state,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          onLoginTap: () {
                            context.read<LoginBloc>().add(LogInPressed(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ));
                          },
                          onRegisterTap: () {
                            context
                                .read<AuthBloc>()
                                .add(LoginRegisterSwitched(isLoginMode: false));
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
                        );
                      },
                    );
                  } else {
                    return BlocConsumer<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterError) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(CustomSnackbar.showSnackBar(
                            message: state.errorMessage,
                          ));
                        } else if (state is RegisterSuccess) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return RegisterView(
                            state: state,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            nameController: _nameController,
                            confirmedPasswordController:
                                _confirmedPasswordController,
                            onRegisterTap: () async {
                              context.read<RegisterBloc>().add(
                                    RegisterPressed(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      username: _nameController.text.trim(),
                                      confirmedPassword:
                                          _confirmedPasswordController.text
                                              .trim(),
                                    ),
                                  );
                            },
                            onLoginTap: () {
                              context.read<AuthBloc>().add(
                                  LoginRegisterSwitched(isLoginMode: true));
                              _emailController.clear();
                              _passwordController.clear();
                              _confirmedPasswordController.clear();
                              _nameController.clear();
                            });
                      },
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
