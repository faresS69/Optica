import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final String id;
  final String name;
  final String description;
  final String address;
  final String ownerId;
  final List<String> images;

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.ownerId,
    required this.images,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      ownerId: json['ownerId'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'ownerId': ownerId,
      'images': images,
    };
  }

  factory Store.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) {
final data = snapshot.data()!;

    return Store(
      id: snapshot.id,
      name: data['name'],
      description: data['description'],
      address: data['address'],
      ownerId: data['ownerId'],
      images: List<String>.from(data['images']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Store &&
              id == other.id &&
              name == other.name &&
              description == other.description &&
              address == other.address &&
              ownerId == other.ownerId &&
              images == other.images);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      address.hashCode ^
      ownerId.hashCode ^
      images.hashCode;
}
