import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profilePictureURL;
  final bool isStoreOwner;
  final String? storeId;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profilePictureURL,
    required this.isStoreOwner,
    this.storeId,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profilePictureURL: json['profilePictureURL'],
      isStoreOwner: json['isStoreOwner'],
      storeId: json['storeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePictureURL': profilePictureURL,
      'isStoreOwner': isStoreOwner,
      'storeId': storeId,
    };
  }

  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AppUser(
      uid: document.id,
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      profilePictureURL: data['profilePictureURL'],
      isStoreOwner: data['isStoreOwner'],
      storeId: data['storeId'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is AppUser &&
              uid == other.uid &&
              name == other.name &&
              email == other.email &&
              phoneNumber == other.phoneNumber &&
              profilePictureURL == other.profilePictureURL &&
              isStoreOwner == other.isStoreOwner &&
              storeId == other.storeId);

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      profilePictureURL.hashCode ^
      isStoreOwner.hashCode ^
      storeId.hashCode;
}
