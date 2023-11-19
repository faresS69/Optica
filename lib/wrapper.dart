import 'package:bng_optica_beta/providers/user_provider.dart';
import 'package:bng_optica_beta/screens/authentication/login_screen.dart';
import 'package:bng_optica_beta/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Widget nextScreen;

  @override
  void initState() {
    super.initState();

    // Fetch user details and determine the next screen
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await context
            .watch<UserProvider>()
            .getUserDetails(user.uid);
        nextScreen = const HomeScreen();
      } else {
        nextScreen = const LoginScreen();
      }

      setState(() {}); // Update UI with the determined next screen
    });
  }

  @override
  Widget build(BuildContext context) {
    // Display the appropriate screen based on user authentication status
    return nextScreen != null
        ? nextScreen
        : const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
