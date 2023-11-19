import 'package:bng_optica_beta/authentication.dart';
import 'package:bng_optica_beta/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../classes/user.dart';
import '../screens/authentication/login_screen.dart';
import '../screens/profile/profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.brown[300],
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  FutureBuilder<AppUser?>(
                    future: _auth.getCurrentUser().catchError((error) {
                      // Handle the error here.
                      // For example, you could display a message to the user.
                      return null;
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final currentUser = snapshot.data;

                        return UserAccountsDrawerHeader(
                          accountName: Text(
                            currentUser!.name,
                            style: drawerItemTextStyle,
                          ),
                          accountEmail: Text(
                            currentUser.email,
                            style: drawerItemTextStyle,
                          ),
                          currentAccountPicture: CircleAvatar(
                            backgroundImage: NetworkImage(currentUser.profilePictureURL!),
                            radius: 70,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.brown[300],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        // Handle the error here.
                        // For example, you could display a message to the user.
                        return Container();
                      } else {
                        // The future is still loading.
                        // Display a progress indicator.
                        return const CircularProgressIndicator();
                      }
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.white),
                    title: Text(
                      'Home',
                      style: drawerItemTextStyle,
                    ),
                    onTap: () {
                      Get.to(const HomeScreen());
                      // Navigate to the home screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: Text(
                      'Profile',
                      style: drawerItemTextStyle,
                    ),
                    onTap: () {
                      Get.to(ProfileScreen(
                        destination: FirebaseAuth.instance.currentUser!.uid,
                      ));
                      // Navigate to the profile screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: Text(
                      'Settings',
                      style: drawerItemTextStyle,
                    ),
                    onTap: () {
                      // Navigate to the settings screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: Text(
                      'Logout',
                      style: drawerItemTextStyle,
                    ),
                    onTap: () async {
                      await _auth.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final TextStyle drawerItemTextStyle = GoogleFonts.abel(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
