import 'package:flutter/material.dart';
import '../models/piggy_bet.dart';
import '../services/checkin_service.dart';
import './countdown_timer.dart';

class BetCard extends StatefulWidget {
  final PiggyBet bet;
  final VoidCallback? onCheckIn;
  final VoidCallback? onRemove;
  final CheckinService? checkinService;

  const BetCard({
    super.key,
    required this.bet,
    this.onCheckIn,
    this.onRemove,
    this.checkinService,
  });

  @override
  State<BetCard> createState() => _BetCardState();
}

class _BetCardState extends State<BetCard> {
  late final CheckinService _checkinService;

  @override
  void initState() {
    super.initState();
    _checkinService = widget.checkinService ?? CheckinService();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final (deadline, needsCheckin) = _checkinService.getNextDeadlineInfo(widget.bet);
    final isExpired = deadline.isBefore(now);
    final isFailed = widget.bet.status == 'failed';

    // Handle expired bet
    if (isExpired && !isFailed && needsCheckin) {
      _checkinService.handleMissedDeadline(widget.bet);
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Challenge section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.bet.challengeCategory,
                        style: TextStyle(
                          color: Colors.deepPurple[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '€${widget.bet.piggyBankValue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.bet.challengeDescription,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.event_repeat,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.bet.frequency,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    if (needsCheckin && !isExpired && !isFailed) CountdownTimer(
                      deadline: deadline,
                      onTimeUp: () {
                        _checkinService.handleMissedDeadline(widget.bet);
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          '🔥 ${widget.bet.streakCount}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '🃏 ${widget.bet.jokerCount}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '🎁 ${widget.bet.rewardTitle}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    const Spacer(),
                    if (needsCheckin && !isExpired && !isFailed)
                      ElevatedButton(
                        onPressed: widget.onCheckIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Done'),
                      )
                    else if (isFailed)
                      OutlinedButton(
                        onPressed: widget.onRemove,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Remove'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}