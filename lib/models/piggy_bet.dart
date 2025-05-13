import 'package:cloud_firestore/cloud_firestore.dart';

class PiggyBet {
  String id;
  String userId;
  String challengeDescription;
  String rewardTitle;
  String rewardCategory;
  double piggyBankValue;
  String frequency;
  DateTime startDate;
  DateTime endDate;
  String participantType; // "self" or "friend"
  String status; // "active", "completed", "failed"
  int streakCount;
  int jokerCount;
  String? participantId;

  PiggyBet({
    required this.id,
    required this.userId,
    required this.challengeDescription,
    required this.rewardTitle,
    required this.rewardCategory,
    required this.piggyBankValue,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.participantType,
    required this.status,
    required this.streakCount,
    required this.jokerCount,
    this.participantId,
  });

  factory PiggyBet.fromMap(Map<String, dynamic> data, String documentId) {
    return PiggyBet(
      id: documentId,
      userId: data['userId'] ?? '',
      challengeDescription: data['challengeDescription'] ?? '',
      rewardTitle: data['rewardTitle'] ?? '',
      rewardCategory: data['rewardCategory'] ?? '',
      piggyBankValue: (data['piggyBankValue'] ?? 0).toDouble(),
      frequency: data['frequency'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      participantType: data['participantType'] ?? 'self',
      status: data['status'] ?? 'active',
      streakCount: data['streakCount'] ?? 0,
      jokerCount: data['jokerCount'] ?? 0,
      participantId: data['participantId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'challengeDescription': challengeDescription,
      'rewardTitle': rewardTitle,
      'rewardCategory': rewardCategory,
      'piggyBankValue': piggyBankValue,
      'frequency': frequency,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'participantType': participantType,
      'status': status,
      'streakCount': streakCount,
      'jokerCount': jokerCount,
      'participantId': participantId,
    };
  }
}
