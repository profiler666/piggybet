import 'package:flutter/material.dart';
import '../../models/piggy_bet.dart';
import '../../services/bet_service.dart';

class PlaceBetScreen extends StatefulWidget {
  const PlaceBetScreen({super.key});

  @override
  State<PlaceBetScreen> createState() => _PlaceBetScreenState();
}

class _PlaceBetScreenState extends State<PlaceBetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _challengeController = TextEditingController();
  final _rewardController = TextEditingController();
  final _betService = BetService();
  
  double _piggyBankValue = 1.0;
  String _frequency = 'everyday';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create PiggyBet')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _challengeController,
              decoration: const InputDecoration(
                labelText: 'What\'s your challenge?',
                hintText: 'e.g., 30 push-ups every day',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a challenge';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rewardController,
              decoration: const InputDecoration(
                labelText: 'What\'s your reward?',
                hintText: 'e.g., Watch a movie',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a reward';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Slider(
              value: _piggyBankValue,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              label: '€${_piggyBankValue.toStringAsFixed(2)}',
              onChanged: (value) => setState(() => _piggyBankValue = value),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitBet,
              child: const Text('Create PiggyBet'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitBet() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final bet = PiggyBet(
          id: '',  // Will be set by Firestore
          userId: 'temp_user_id', // TODO: Get from AuthService
          challengeDescription: _challengeController.text,
          rewardTitle: _rewardController.text,
          rewardCategory: 'default',
          piggyBankValue: _piggyBankValue,
          frequency: _frequency,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 28)),
          participantType: 'self',
          status: 'active',
          streakCount: 0,
          jokerCount: 0,
        );

        await _betService.createBet(bet);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bet created successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating bet: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _challengeController.dispose();
    _rewardController.dispose();
    super.dispose();
  }
}
