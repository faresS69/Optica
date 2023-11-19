import 'dart:convert';

import 'package:bng_optica_beta/screens/authentication/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'classes/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// User registration using email and password
  Future<void> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      // Create a Firebase user
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create an AppUser object
      final appUser = AppUser(
        uid: FirebaseAuth.instance.currentUser!.uid,
        name: name,
        email: email,
        phoneNumber: '',
        profilePictureURL: '',
        isStoreOwner: false,
        storeId: '',
      );

      // Save AppUser to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(appUser.toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email already in use');
      } else if (e.code == 'weak-password') {
        throw Exception('Password is too weak');
      } else {
        throw Exception('Registration failed');
      }
    }
  }

  /// User login using email and password
  Future<AppUser?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential user =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user.user != null) {
        final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.user?.uid)
                .get();

        // Create a new AppUser object from the user data
        final AppUser appUser = AppUser.fromDocument(userSnapshot);

        // Store the current user data in SharedPreferences
        await setCurrentUser(appUser);

        return appUser;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('User not found');
      } else if (e.code == 'wrong-password') {
        throw Exception('Invalid password');
      } else {
        throw Exception(e.message.toString());
      }
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    Get.off(() => const LoginScreen());
  }

  Future<void> setCurrentUser(AppUser appUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', appUser.uid);
  }

  Future<AppUser?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUserJson = prefs.getString('currentUser');

    if (currentUserJson != null) {
      return AppUser.fromJson(json.decode(currentUserJson));
    } else {
      return null;
    }
  }
}
