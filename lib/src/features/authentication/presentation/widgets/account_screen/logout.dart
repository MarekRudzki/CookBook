import 'package:cookbook/src/features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/logout/logout_bloc.dart';
import 'package:cookbook/src/features/authentication/presentation/screens/login_screen.dart';
import 'package:cookbook/src/features/common_widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LogOut extends StatelessWidget {
  const LogOut({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutBloc, LogoutState>(
      listener: (context, blocState) {
        if (blocState is LogoutSuccess) {
          context
              .read<AuthBloc>()
              .add(LoginRegisterSwitched(isLoginMode: true));
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } else if (blocState is LogoutError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(CustomSnackbar.showSnackBar(
            message: blocState.errorMessage,
          ));
        }
      },
      builder: (context, state) {
        if (state is LogoutLoading) {
          return const SpinKitThreeBounce(
            size: 25,
            color: Colors.white,
          );
        } else {
          return Center(
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                context.read<LogoutBloc>().add(LogOutPressed());
              },
              label: Text(
                'Log out',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          );
        }
      },
    );
  }
}
