import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/piggy_bet.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class BetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createBet(PiggyBet bet) async {
    try {
      debugPrint('Starting to create bet...');
      debugPrint('Bet data: ${bet.toMap()}');
      
      final docRef = await _firestore.collection('bets').add(bet.toMap());
      debugPrint('Document created with ID: ${docRef.id}');
      
      await docRef.update({'id': docRef.id});
      debugPrint('Document updated with ID');
    } catch (e) {
      debugPrint('Error creating bet: $e');
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
}