import 'package:cookbook/src/services/shared_prefs.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../../src/core/constants.dart';
import '../../../../src/presentation/screens/login/login_screen.dart';

import '../../../services/firebase/auth.dart';
import 'widgets/settings_tile.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final Auth _auth = Auth();
  final SharedPrefs _sharedPrefs = SharedPrefs();

  Future<void> deleteAccount() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    await _auth.deleteUser().then((errorText) {
      if (errorText.isNotEmpty) {
        print(errorText); //TODO handle this error
      } else {
        _sharedPrefs.removeUser();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  Future<void> logOut() async {
    await _auth.signOut().then((errorText) {
      if (errorText.isNotEmpty) {
        print(errorText); //TODO handle this error
      } else {
        _sharedPrefs.removeUser();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kLighterBlue,
              kDartBlue,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: GoogleFonts.oswald(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            'Username: ',
                            style: GoogleFonts.robotoSlab(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            'Email: ${_auth.email}',
                            style: GoogleFonts.robotoSlab(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Edit profile',
                style: GoogleFonts.oswald(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SettingsTile(
                icon: Icons.edit,
                tileText: 'Change username',
                onPressed:
                    () {}, //TODO Dodać wyskakujący ekran na którym można zmienić dane, i gdzie te zostaną spradzone
              ),
              const SizedBox(
                height: 5,
              ),
              SettingsTile(
                icon: Icons.key,
                tileText: 'Change password',
                onPressed: () {},
              ),
              const SizedBox(
                height: 5,
              ),
              SettingsTile(
                icon: Icons.delete_forever,
                tileText: 'Delete account',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Are you sure?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        content: const Text(
                          'This action will permanently delete your account',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        backgroundColor: kLighterBlue,
                        actions: [
                          IconButton(
                            onPressed: deleteAccount,
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kLighterBlue,
                  ),
                  onPressed: () {
                    logOut();
                  },
                  label: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
