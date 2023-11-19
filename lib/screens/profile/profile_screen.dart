import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String destination;
  const ProfileScreen({super.key, required this.destination});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FirebaseAuth.instance.currentUser!.uid == widget.destination ? IconButton(onPressed: (){}, icon: const Icon(Icons.edit)) : const SizedBox()
        ],
      ),
    );
  }
}
