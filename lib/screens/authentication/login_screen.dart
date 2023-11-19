import 'package:bng_optica_beta/authentication.dart';
import 'package:bng_optica_beta/screens/authentication/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService _auth = AuthenticationService();
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLogin = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: GoogleFonts.abel(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                  Get.snackbar('Error', 'Please enter both email and password');
                  return;
                }
                try {
                  await _auth.loginWithEmailAndPassword(_emailController.text, _passwordController.text);
                  // Navigate to home screen
                  Get.off(const HomeScreen());
                } on FirebaseAuthException catch (e) {
                  // Display error message
                  if (e.code == 'user-not-found') {
                    Get.snackbar('Error', 'User not found');
                  } else if (e.code == 'wrong-password') {
                    Get.snackbar('Error', 'Invalid password');
                  } else {
                    Get.snackbar('Error', 'Login failed');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown,
              ),
              child: Text(
                'Login',
                style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // Add your Google login logic here
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown,
                padding: const EdgeInsets.all(10),
              ),
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(FontAwesomeIcons.google),
              ),
              label: Text(
                'Login with Google',
                style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 20, wordSpacing: 5),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Get.off(const SignupScreen());
              },
              child: const Text(
                'Don\'t have an account? Sign up',
                style: TextStyle(color: Colors.brown),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
