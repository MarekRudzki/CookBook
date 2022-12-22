import 'package:flutter/material.dart';

import 'login_action_button.dart';
import 'login_text_input_field.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.confirmedPasswordController,
    required this.onLoginTap,
    required this.onRegisterTap,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController confirmedPasswordController;
  final Function() onLoginTap;
  final Function() onRegisterTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.17,
        ),
        LoginTextInputField(
          controller: nameController,
          labelText: 'Enter your name',
          icon: Icons.person,
        ),
        LoginTextInputField(
          controller: emailController,
          labelText: 'Enter your email',
          icon: Icons.email_outlined,
        ),
        LoginTextInputField(
          controller: passwordController,
          labelText: 'Enter your password',
          obscure: true,
          icon: Icons.key,
        ),
        LoginTextInputField(
          controller: confirmedPasswordController,
          labelText: 'Confirm your password',
          obscure: true,
          inputAction: TextInputAction.done,
          icon: Icons.key,
        ),
        const SizedBox(
          height: 14,
        ),
        ActionButton(
          text: 'Register',
          context: context,
          onTap: onRegisterTap,
        ),
        const SizedBox(
          height: 5,
        ),
        TextButton(
          onPressed: onLoginTap,
          child: Text(
            'Already have an account? Try login',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        ),
      ],
    );
  }
}
