import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/invite.dart';
import './app_links_service.dart';

class InviteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AppLinksService _appLinksService = AppLinksService();

  Future<String> createInvite({
    required String betId,
    required String inviterId,
    required String challengeText,
    required String rewardText,
  }) async {
    try {
      // Create invite record in Firestore
      final invite = Invite(
        id: '',
        betId: betId,
        inviterId: inviterId,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      final docRef = await _firestore.collection('invites').add(invite.toMap());
      await docRef.update({'id': docRef.id});

      // Generate app link with challenge preview
      final encodedChallenge = Uri.encodeComponent(challengeText);
      final encodedReward = Uri.encodeComponent(rewardText);
      final inviteLink = await _appLinksService.createInviteLink(
        betId: betId,
        challenge: encodedChallenge,
        reward: encodedReward,
      );
      return inviteLink;
    } catch (e) {
      throw Exception('Failed to create invite: $e');
    }
  }

  Future<Invite?> getInvite(String inviteId) async {
    try {
      final doc = await _firestore.collection('invites').doc(inviteId).get();
      if (!doc.exists) return null;
      return Invite.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get invite: $e');
    }
  }
}