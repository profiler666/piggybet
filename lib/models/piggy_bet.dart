import 'package:cloud_firestore/cloud_firestore.dart';

class PiggyBet {
  static const int maxJokers = 3;

  final String id;
  final String userId;
  final String challengeCategory;
  final String challengeDescription;
  final String rewardTitle;
  final String rewardCategory;
  final double piggyBankValue;
  final String frequency;
  final DateTime startDate;
  final DateTime endDate;
  final String participantType;
  final String status;
  final int streakCount;
  final int jokerCount;
  final DateTime createdAt;  // Add this field
  final DateTime? lastCheckinAt;  // Add this field

  PiggyBet({
    required this.id,
    required this.userId,
    required this.challengeCategory,
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
    required this.createdAt,  // Add this
    this.lastCheckinAt,  // Add this
  });

  factory PiggyBet.fromMap(Map<String, dynamic> map, String documentId) {
    return PiggyBet(
      id: documentId,
      userId: map['userId']?.toString() ?? '',
      challengeCategory: map['challengeCategory']?.toString() ?? '',
      challengeDescription: map['challengeDescription']?.toString() ?? '',
      rewardTitle: map['rewardTitle']?.toString() ?? '',
      rewardCategory: map['rewardCategory']?.toString() ?? '',
      piggyBankValue: (map['piggyBankValue'] ?? 0.0).toDouble(),
      frequency: map['frequency']?.toString() ?? 'everyday',
      startDate: (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (map['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      participantType: map['participantType']?.toString() ?? 'self',
      status: map['status']?.toString() ?? 'active',
      streakCount: (map['streakCount'] ?? 0) as int,
      jokerCount: (map['jokerCount'] ?? 0) as int,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastCheckinAt: (map['lastCheckinAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'challengeCategory': challengeCategory,
      'challengeDescription': challengeDescription,
      'rewardTitle': rewardTitle,
      'rewardCategory': rewardCategory,
      'piggyBankValue': piggyBankValue,
      'frequency': frequency,
      'startDate': startDate,
      'endDate': endDate,
      'participantType': participantType,
      'status': status,
      'streakCount': streakCount,
      'jokerCount': jokerCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastCheckinAt': lastCheckinAt != null ? Timestamp.fromDate(lastCheckinAt!) : null,
    };
  }
}
