import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/piggy_bet.dart';

class CheckinService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Returns the next deadline and whether the current period needs a check-in
  (DateTime deadline, bool needsCheckin) getNextDeadlineInfo(PiggyBet bet) {
    final now = DateTime.now();
    final referenceTime = bet.createdAt; // Always use creation time as reference
    
    Duration interval;
    switch (bet.frequency) {
      case 'every minute':
        interval = const Duration(minutes: 1);
        break;
      case 'everyday':
        interval = const Duration(days: 1);
        break;
      case 'weekly':
        interval = const Duration(days: 7);
        break;
      default:
        interval = const Duration(days: 1);
    }

    // Find the current period's start and end
    var periodStart = DateTime(
      referenceTime.year,
      referenceTime.month,
      referenceTime.day,
      referenceTime.hour,
      referenceTime.minute,
      referenceTime.second,
    );

    // Find which period we're in
    while (periodStart.add(interval).isBefore(now)) {
      periodStart = periodStart.add(interval);
    }
    final periodEnd = periodStart.add(interval);

    // Check if we need a check-in for this period
    final lastCheckin = bet.lastCheckinAt;
    final needsCheckin = lastCheckin == null || 
                        lastCheckin.isBefore(periodStart) ||
                        lastCheckin.isAfter(periodEnd);

    return (periodEnd, needsCheckin);
  }

  Future<void> recordCheckin(String betId) async {
    try {
      final betRef = _firestore.collection('bets').doc(betId);
      final betDoc = await betRef.get();
      
      if (!betDoc.exists) {
        throw Exception('Bet not found');
      }

      final currentStreak = betDoc.data()?['streakCount'] ?? 0;
      final currentJokers = betDoc.data()?['jokerCount'] ?? 0;
      
      // Record check-in time and update streak
      await betRef.update({
        'streakCount': currentStreak + 1,
        'lastCheckinAt': Timestamp.now(),
      });

      // Award joker after 7 consecutive check-ins (if below max)
      if ((currentStreak + 1) % 7 == 0 && currentJokers < PiggyBet.maxJokers) {
        await betRef.update({
          'jokerCount': FieldValue.increment(1),
        });
      }
    } catch (e) {
      throw Exception('Failed to record check-in: $e');
    }
  }

  Future<void> handleMissedDeadline(PiggyBet bet) async {
    try {
      final betRef = _firestore.collection('bets').doc(bet.id);
      final betDoc = await betRef.get();
      
      if (!betDoc.exists) {
        throw Exception('Bet not found');
      }

      final currentJokers = betDoc.data()?['jokerCount'] ?? 0;
      
      if (currentJokers > 0) {
        // Use a joker automatically
        await betRef.update({
          'jokerCount': currentJokers - 1,
          'lastCheckinAt': Timestamp.now(), // Reset deadline
          'streakCount': 0, // Reset streak when using joker
        });
      } else {
        // Mark as failed if no jokers left
        await betRef.update({
          'status': 'failed',
          'failedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      throw Exception('Failed to handle missed deadline: $e');
    }
  }
}