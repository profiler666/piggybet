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
  
  // New controllers and variables
  String _challengeCategory = 'Routine';
  String _frequency = 'everyday';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 28));
  double _piggyBankValue = 1.0;
  String _rewardCategory = 'Self-care';
  String _participantType = 'self';

  // Predefined options
  final List<String> _challengeCategories = ['Routine', 'Wellness', 'Learning', 'Fitness'];
  final List<String> _frequencies = ['everyday', 'weekly', 'weekdays', 'weekends'];
  final List<String> _rewardCategories = ['Self-care', 'Entertainment', 'Food', 'Shopping'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create PiggyBet')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Challenge Section
            const Text(
              'Challenge Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _challengeCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _challengeCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _challengeCategory = value ?? 'Routine';
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _challengeController,
              decoration: const InputDecoration(
                labelText: 'What\'s your challenge?',
                hintText: 'e.g., 30 push-ups every day',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter a challenge' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: const InputDecoration(labelText: 'Frequency'),
              items: _frequencies.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(frequency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _frequency = value ?? 'everyday';
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Start Date'),
                    subtitle: Text(_startDate.toString().split(' ')[0]),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          _startDate = picked;
                          _endDate = picked.add(const Duration(days: 28));
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('End Date'),
                    subtitle: Text(_endDate.toString().split(' ')[0]),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: _startDate,
                        lastDate: _startDate.add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() {
                          _endDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            // Reward Section
            const Text(
              'Reward Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _rewardCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _rewardCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _rewardCategory = value ?? 'Self-care';
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rewardController,
              decoration: const InputDecoration(
                labelText: 'What\'s your reward?',
                hintText: 'e.g., One day at the SPA',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter a reward' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Piggy Bank Value: €${_piggyBankValue.toStringAsFixed(2)}'),
              subtitle: Slider(
                value: _piggyBankValue,
                min: 1.0,
                max: 10.0,
                divisions: 9,
                label: '€${_piggyBankValue.toStringAsFixed(2)}',
                onChanged: (value) => setState(() => _piggyBankValue = value),
              ),
            ),

            const SizedBox(height: 32),
            // Participant Section
            const Text(
              'Who will do this challenge?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _participantType = 'self'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _participantType == 'self' ? Colors.deepPurple : null,
                  ),
                  child: const Text('Bet on Myself'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => _participantType = 'friend'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _participantType == 'friend' ? Colors.deepPurple : null,
                  ),
                  child: const Text('Invite a Friend'),
                ),
              ],
            ),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitBet,
              child: const Text('Create PiggyBet'),
            ),
          ],
        ),
      ),
    );
  }

  // Update _submitBet to include all parameters
  Future<void> _submitBet() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final bet = PiggyBet(
          id: '',
          userId: 'temp_user_id',
          challengeCategory: _challengeCategory,  // Add this line
          challengeDescription: _challengeController.text,
          rewardTitle: _rewardController.text,
          rewardCategory: _rewardCategory,
          piggyBankValue: _piggyBankValue,
          frequency: _frequency,
          startDate: _startDate,
          endDate: _endDate,
          participantType: _participantType,
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
