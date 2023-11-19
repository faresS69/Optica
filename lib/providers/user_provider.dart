import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../classes/user.dart';

class UserProvider with ChangeNotifier {
  AppUser? _user;

  AppUser? get getUser => _user;

  getUserDetails(String? uid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    _user = AppUser.fromJson(documentSnapshot.data() as Map<String, dynamic>);

    notifyListeners();
  }
}
