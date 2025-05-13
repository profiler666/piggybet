import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/place_bet/place_bet_screen.dart';
import '../features/join_bet/join_bet_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/settings/settings_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String placeBet = '/place-bet';
  static const String joinBet = '/join-bet';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String? path = settings.name;

    if (path == home) {
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
    if (path == placeBet) {
      return MaterialPageRoute(builder: (_) => const PlaceBetScreen());
    }
    if (path == joinBet) {
      return MaterialPageRoute(builder: (_) => const JoinBetScreen());
    }
    if (path == notifications) {
      return MaterialPageRoute(builder: (_) => const NotificationsScreen());
    }
    if (path == settings) {
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    }

    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('No route defined for $path')),
      ),
    );
  }
}