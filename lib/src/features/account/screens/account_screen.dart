import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../features/common_widgets/custom_alert_dialog.dart';
import '../../../core/constants.dart';
import '../../../services/firebase/auth.dart';
import '../../../services/shared_prefs.dart';
import '../../common_widgets/error_handling.dart';
import '../../login/login_screen.dart';
import '../account_provider.dart';
import '../widgets/settings_tile.dart';
import '/src/services/firebase/firestore.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final TextEditingController _changeUsernameConroller;
  late final TextEditingController _changePasswordConroller;
  final Auth _auth = Auth();
  final SharedPrefs _sharedPrefs = SharedPrefs();
  final ErrorHandling _errorHandling = ErrorHandling();
  final Firestore _firestore = Firestore();

  @override
  void initState() {
    super.initState();
    _changeUsernameConroller = TextEditingController();
    _changePasswordConroller = TextEditingController();
  }

  @override
  void dispose() {
    _changeUsernameConroller.dispose();
    _changePasswordConroller.dispose();
    super.dispose();
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
                            'Username: ${Provider.of<AccountProvider>(context, listen: false).username}',
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
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return CustromAlertDialog(
                          title: 'Change username?',
                          content: 'Enter new username you want to use',
                          labelText: 'Input new username',
                          controller: _changeUsernameConroller,
                          onConfirmed: () async {
                            await _firestore
                                .addUser(_changeUsernameConroller.text)
                                .then((errorText) {
                              if (errorText.isNotEmpty) {
                                _errorHandling.showErrorSnackbar(
                                    context, errorText);
                              } else {
                                Provider.of<AccountProvider>(context,
                                        listen: false)
                                    .changeUsername(
                                  _changeUsernameConroller.text,
                                );
                                Navigator.of(context).pop();
                              }
                            });
                          },
                        );
                      });
                },
              ),
              const SizedBox(
                height: 5,
              ),
              SettingsTile(
                icon: Icons.key,
                tileText: 'Change password',
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return CustromAlertDialog(
                        title: 'Change password?',
                        content: 'Enter your new password',
                        labelText: 'Input new password',
                        controller: _changePasswordConroller,
                        onConfirmed: () {},
                      );
                    },
                  );
                },
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
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              );
                              await _auth.deleteUser().then((errorText) {
                                if (errorText.isNotEmpty) {
                                  _errorHandling.showErrorSnackbar(
                                      context, errorText);
                                } else {
                                  _sharedPrefs.removeUser();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                }
                              });
                            },
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
                  onPressed: () async {
                    await _auth.signOut().then((errorText) {
                      if (errorText.isNotEmpty) {
                        _errorHandling.showErrorSnackbar(context, errorText);
                      } else {
                        _sharedPrefs.removeUser();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    });
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
