import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String id;
  final String senderUid;
  final String receiverUid;
  final String storeId;
  final String description;
  final DateTime createdAt;

  Request({
    required this.id,
    required this.senderUid,
    required this.receiverUid,
    required this.storeId,
    required this.description,
    required this.createdAt,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      storeId: json['storeId'],
      description: json['description'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'storeId': storeId,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Request.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Request(
      id: document.id,
      senderUid: data['senderUid'],
      receiverUid: data['receiverUid'],
      storeId: data['storeId'],
      description: data['description'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Request &&
              id == other.id &&
              senderUid == other.senderUid &&
              receiverUid == other.receiverUid &&
              storeId == other.storeId &&
              description == other.description &&
              createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      senderUid.hashCode ^
      receiverUid.hashCode ^
      storeId.hashCode ^
      description.hashCode ^
      createdAt.hashCode;
}
