import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/piggy_bet.dart';

class BetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBet(PiggyBet bet) async {
    try {
      final betData = bet.toMap();
      betData['createdAt'] = Timestamp.now();  // Set creation time
      
      final docRef = await _firestore.collection('bets').add(betData);
      await docRef.update({'id': docRef.id});
    } catch (e) {
      throw Exception('Failed to create bet: $e');
    }
  }

  Future<List<PiggyBet>> getUserBets(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('bets')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => PiggyBet.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user bets: $e');
    }
  }

  Future<void> deleteBet(String betId) async {
    try {
      await _firestore.collection('bets').doc(betId).delete();
    } catch (e) {
      throw Exception('Failed to delete bet: $e');
    }
  }
}