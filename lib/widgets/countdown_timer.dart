import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final DateTime deadline;
  final VoidCallback onTimeUp;

  const CountdownTimer({
    super.key,
    required this.deadline,
    required this.onTimeUp,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _timeLeft = const Duration();

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _calculateTimeLeft());
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    final difference = widget.deadline.difference(now);
    
    if (mounted) {
      setState(() {
        _timeLeft = difference.isNegative ? const Duration() : difference;
      });
    }

    if (difference.isNegative) {
      _timer.cancel();
      widget.onTimeUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours = _timeLeft.inHours;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return Text(
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _timeLeft.inHours < 2 ? Colors.red : Colors.grey[600],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}