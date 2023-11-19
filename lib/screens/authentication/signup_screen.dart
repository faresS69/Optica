import 'package:bng_optica_beta/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _auth = AuthenticationService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              'Sign Up',
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
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
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
                // Validate user input
                if (_emailController.text.isEmpty || _nameController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  Get.snackbar('Error', 'Please fill in all required fields');
                  return;
                }

                // Handle Firebase registration
                try {
                  await _auth.registerWithEmailAndPassword(_emailController.text, _passwordController.text, _nameController.text);
                  // Navigate back to login screen
                  Get.off(const LoginScreen());
                } on FirebaseAuthException catch (e) {
                  // Display error message
                  if (e.code == 'email-already-in-use') {
                    Get.snackbar('Error', 'Email already in use');
                  } else if (e.code == 'weak-password') {
                    Get.snackbar('Error', 'Password is too weak');
                  } else {
                    Get.snackbar('Error', 'Registration failed');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown,
              ),
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Get.off(const LoginScreen());
                // Add your sign-up screen navigation logic here
              },
              child: const Text(
                'Already have an account? Login',
                style: TextStyle(color: Colors.brown),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
