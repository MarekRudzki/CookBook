import 'package:flutter/material.dart';

import 'login_text_input_field.dart';
import 'login_action_button.dart';

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
  final void Function() onLoginTap;
  final void Function() onRegisterTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        reverse: true,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 18, 76, 135).withOpacity(0.75),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: onLoginTap,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Try login',
                      style: TextStyle(
                        backgroundColor: Colors.transparent,
                        color: Colors.blueAccent,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
