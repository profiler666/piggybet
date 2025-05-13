import 'package:flutter/material.dart';
import '../../models/piggy_bet.dart';
import '../../services/bet_service.dart';
import '../../services/checkin_service.dart';
import '../../widgets/bet_card.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _betService = BetService();
  final _checkinService = CheckinService();
  
  Future<void> _handleCheckIn(PiggyBet bet) async {
    try {
      await _checkinService.recordCheckin(bet.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check-in recorded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error recording check-in: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In'),
      ),
      body: FutureBuilder<List<PiggyBet>>(
        future: _betService.getUserBets('temp_user_id'), // TODO: Get real user ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final bets = snapshot.data ?? [];
          
          if (bets.isEmpty) {
            return const Center(
              child: Text('No active bets found. Create one to get started!'),
            );
          }

          return ListView.builder(
            itemCount: bets.length,
            itemBuilder: (context, index) {
              final bet = bets[index];
              return BetCard(
                bet: bet,
                onCheckIn: () => _handleCheckIn(bet),
              );
            },
          );
        },
      ),
    );
  }
}