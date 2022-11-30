import 'package:cookbook/constants.dart';
import 'package:cookbook/screens/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User user = FirebaseAuth.instance.currentUser!;
  Future deleteAccount([bool mounted = true]) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    await user.delete();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              darkThemeGradientFirst,
              darkThemeGradientSecond,
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
                            'Username: ', //TODO get from local memory
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
                            'Email: ${user.email!}',
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
              SettingTile(
                icon: Icons.edit,
                tileText: 'Change username',
                onPressed:
                    () {}, //TODO Dodać wyskakujący ekran na którym można zmienić dane, i gdzie te zostaną spradzone
              ),
              const SizedBox(
                height: 5,
              ),
              SettingTile(
                icon: Icons.key,
                tileText: 'Change password',
                onPressed: () {},
              ),
              const SizedBox(
                height: 5,
              ),
              SettingTile(
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
                          backgroundColor: darkThemeGradientFirst,
                          actions: [
                            IconButton(
                              onPressed: () {
                                deleteAccount();
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
                            )
                          ],
                        );
                      });
                },
              ),
              const Spacer(),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkThemeGradientFirst,
                  ),
                  onPressed: logOut,
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

class SettingTile extends StatelessWidget {
  SettingTile({
    Key? key,
    required this.icon,
    required this.tileText,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String tileText;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 15,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: Text(
                  tileText,
                  style: GoogleFonts.robotoSlab(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
