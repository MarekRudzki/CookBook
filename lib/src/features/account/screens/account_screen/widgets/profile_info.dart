import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../account_provider.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
    required this.accountProvider,
  });

  final AccountProvider accountProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColorDark,
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
                const SizedBox(
                  width: 7,
                ),
                if (accountProvider.username == '')
                  FutureBuilder(
                    future: accountProvider.getUsername(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          'Username: ${snapshot.data}',
                          style: Theme.of(context).textTheme.bodyText2,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  )
                else
                  Text(
                    'Username: ${context.select((AccountProvider account) => account.username)}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
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
                  'Email: ${accountProvider.getEmail()}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
