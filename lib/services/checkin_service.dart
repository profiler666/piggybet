import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/piggy_bet.dart';

class CheckinService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime getNextDeadline(PiggyBet bet) {
    final now = DateTime.now();
    
    // Get the reference time (either last check-in or creation time)
    final referenceTime = bet.lastCheckinAt ?? bet.createdAt;
    
    // Calculate next deadline based on frequency
    switch (bet.frequency) {
      case 'everyday':
        // Calculate next deadline based on creation time
        var nextDeadline = DateTime(
          referenceTime.year,
          referenceTime.month,
          referenceTime.day,
          bet.createdAt.hour,
          bet.createdAt.minute,
          bet.createdAt.second,
        );

        // If we're past that time, add 24 hours
        while (nextDeadline.isBefore(now)) {
          nextDeadline = nextDeadline.add(const Duration(days: 1));
        }
        return nextDeadline;

      case 'weekly':
        // Start from reference time and add weeks until we find next deadline
        var nextDeadline = DateTime(
          referenceTime.year,
          referenceTime.month,
          referenceTime.day,
          bet.createdAt.hour,
          bet.createdAt.minute,
          bet.createdAt.second,
        );

        while (nextDeadline.isBefore(now)) {
          nextDeadline = nextDeadline.add(const Duration(days: 7));
        }
        return nextDeadline;

      case 'weekdays':
        // Start from reference time
        var nextDeadline = DateTime(
          referenceTime.year,
          referenceTime.month,
          referenceTime.day,
          bet.createdAt.hour,
          bet.createdAt.minute,
          bet.createdAt.second,
        );

        while (nextDeadline.isBefore(now) || 
               nextDeadline.weekday == DateTime.saturday || 
               nextDeadline.weekday == DateTime.sunday) {
          nextDeadline = nextDeadline.add(const Duration(days: 1));
        }
        return nextDeadline;

      case 'weekends':
        // Start from reference time
        var nextDeadline = DateTime(
          referenceTime.year,
          referenceTime.month,
          referenceTime.day,
          bet.createdAt.hour,
          bet.createdAt.minute,
          bet.createdAt.second,
        );

        while (nextDeadline.isBefore(now) || 
               nextDeadline.weekday < DateTime.saturday) {
          nextDeadline = nextDeadline.add(const Duration(days: 1));
        }
        return nextDeadline;

      default:
        return DateTime(
          referenceTime.year,
          referenceTime.month,
          referenceTime.day,
          bet.createdAt.hour,
          bet.createdAt.minute,
          bet.createdAt.second,
        ).add(const Duration(days: 1));
    }
  }

  Future<void> recordCheckin(String betId) async {
    try {
      final betRef = _firestore.collection('bets').doc(betId);
      final betDoc = await betRef.get();
      
      if (!betDoc.exists) {
        throw Exception('Bet not found');
      }

      final currentStreak = betDoc.data()?['streakCount'] ?? 0;
      
      await betRef.update({
        'streakCount': currentStreak + 1,
        'lastCheckinAt': Timestamp.now(),
      });

      // Award joker after 7 consecutive check-ins
      if ((currentStreak + 1) % 7 == 0) {
        await betRef.update({
          'jokerCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      throw Exception('Failed to record check-in: $e');
    }
  }
}