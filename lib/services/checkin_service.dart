import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class CheckinService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> recordCheckin(String betId) async {
    try {
      debugPrint('Recording check-in for bet: $betId');
      
      final betRef = _firestore.collection('bets').doc(betId);
      final betDoc = await betRef.get();
      
      if (!betDoc.exists) {
        throw Exception('Bet not found');
      }

      final currentStreak = betDoc.data()?['streakCount'] ?? 0;
      
      await betRef.update({
        'streakCount': currentStreak + 1,
        'lastCheckin': Timestamp.now(),
      });
      
      debugPrint('Check-in recorded successfully');
    } catch (e) {
      debugPrint('Error recording check-in: $e');
      throw Exception('Failed to record check-in: $e');
    }
  }
}