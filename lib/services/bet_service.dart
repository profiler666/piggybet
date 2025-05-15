import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/piggy_bet.dart';
import './auth_service.dart';

class BetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  Future<void> createBet(PiggyBet bet) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('User must be authenticated to create a bet');
      }

      final betData = bet.toMap();
      betData['userId'] = userId;
      betData['createdAt'] = Timestamp.now();
      
      final docRef = await _firestore.collection('bets').add(betData);
      await docRef.update({'id': docRef.id});
    } catch (e) {
      throw Exception('Failed to create bet: $e');
    }
  }

  Future<List<PiggyBet>> getUserBets(String? userId) async {
    try {
      // Use current user's ID if none provided
      final currentUserId = userId ?? _authService.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('No user ID available');
      }

      final snapshot = await _firestore
          .collection('bets')
          .where('userId', isEqualTo: currentUserId)
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