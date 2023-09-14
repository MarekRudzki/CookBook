import 'package:cookbook/src/core/di.dart';
import 'package:cookbook/src/features/authentication/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo();

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(UsernameRequested());
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 7),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is UsernameLoaded) {
                      return Text(
                        state.username,
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    } else if (state is AuthLoading) {
                      return const SpinKitThreeBounce(
                        size: 25,
                        color: Colors.white,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(
                  Icons.mail,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 7),
                Text(
                  getIt<AuthBloc>().getEmail(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
