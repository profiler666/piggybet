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
  
  int _currentStep = 0;
  
  // Challenge step
  String _challengeCategory = 'Routine';
  String _frequency = 'everyday';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 28));
  
  // Reward step
  String _rewardCategory = 'Self-care';
  double _piggyBankValue = 1.0;
  
  // Participant step
  String _participantType = 'self';

  final List<String> _challengeCategories = ['Routine', 'Wellness', 'Learning', 'Fitness'];
  final List<String> _frequencies = [
    'every minute', // For testing
    'everyday',
    'weekly',
  ];
  final List<String> _rewardCategories = ['Self-care', 'Entertainment', 'Food', 'Shopping'];

  Widget _buildChallengeStep() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _currentStep == 0 ? 1.0 : 0.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s your challenge?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _challengeCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _challengeCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) => setState(() => _challengeCategory = value!),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _challengeController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'e.g., 30 push-ups',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter a challenge' : null,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
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
                          // Ensure end date is not before start date
                          if (_endDate.isBefore(_startDate)) {
                            _endDate = _startDate.add(const Duration(days: 28));
                          }
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: _startDate,
                        lastDate: _startDate.add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _endDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Duration: ${_endDate.difference(_startDate).inDays + 1} days',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: const InputDecoration(
                labelText: 'How often?',
                border: OutlineInputBorder(),
              ),
              items: _frequencies.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(frequency),
                );
              }).toList(),
              onChanged: (value) => setState(() => _frequency = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardStep() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _currentStep == 1 ? 1.0 : 0.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your reward',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _rewardCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _rewardCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) => setState(() => _rewardCategory = value!),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _rewardController,
              decoration: const InputDecoration(
                labelText: 'What\'s your reward?',
                hintText: 'e.g., One day at the SPA',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Please enter a reward' : null,
            ),
            const SizedBox(height: 20),
            Text('Piggy Bank Value: €${_piggyBankValue.toStringAsFixed(2)}'),
            Slider(
              value: _piggyBankValue,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              label: '€${_piggyBankValue.toStringAsFixed(2)}',
              onChanged: (value) => setState(() => _piggyBankValue = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantStep() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _currentStep == 2 ? 1.0 : 0.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Who\'s taking this challenge?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildParticipantOption(
                  icon: Icons.person,
                  title: 'Bet on Myself',
                  isSelected: _participantType == 'self',
                  onTap: () => setState(() => _participantType = 'self'),
                ),
                _buildParticipantOption(
                  icon: Icons.people,
                  title: 'Invite a Friend',
                  isSelected: _participantType == 'friend',
                  onTap: () => setState(() => _participantType = 'friend'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? Colors.deepPurple : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.deepPurple : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          ['Challenge', 'Reward', 'Participant'][_currentStep],
          style: const TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / 3,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: [
                    _buildChallengeStep(),
                    _buildRewardStep(),
                    _buildParticipantStep(),
                  ][_currentStep],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: () => setState(() => _currentStep--),
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox.shrink(),
                  ElevatedButton(
                    onPressed: _currentStep < 2 
                        ? () => setState(() => _currentStep++)
                        : _submitBet,
                    child: Text(_currentStep < 2 ? 'Next' : 'Create PiggyBet'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitBet() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Show loading indicator
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Creating your PiggyBet...')),
        );

        final bet = PiggyBet(
          id: '',
          userId: 'temp_user_id',
          challengeCategory: _challengeCategory,
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
          createdAt: DateTime.now(),  // Add this line
          lastCheckinAt: null,  // Add this line
        );

        await _betService.createBet(bet);

        if (!mounted) return;

        // Navigate to home screen using named route
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/', // Home route
          (route) => false, // Remove all previous routes
        );

        // Show success message after navigation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PiggyBet created successfully!')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating bet: $e')),
        );
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
