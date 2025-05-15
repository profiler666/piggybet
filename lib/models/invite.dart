import 'package:cloud_firestore/cloud_firestore.dart';

class Invite {
  final String id;
  final String betId;
  final String inviterId;
  final String status;
  final DateTime createdAt;

  const Invite({
    required this.id,
    required this.betId,
    required this.inviterId,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'betId': betId,
      'inviterId': inviterId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Invite.fromMap(Map<String, dynamic> map, String id) {
    return Invite(
      id: id,
      betId: map['betId'] ?? '',
      inviterId: map['inviterId'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}