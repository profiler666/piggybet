import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';

class AppLinksService {
  static const String APP_SCHEME = 'https';
  static const String APP_HOST = 'profiler666.github.io';
  static const String APP_PATH = 'piggybet';

  Future<String> createInviteLink({
    required String betId,
    required String challenge,
    required String reward,
  }) async {
    return '$APP_SCHEME://$APP_HOST/$APP_PATH/join.html?betId=$betId&challenge=$challenge&reward=$reward';
  }

  Stream<Uri> get uriLinkStream => AppLinks().uriLinkStream;

  Future<Uri?> getInitialLink() async {
    try {
      return await AppLinks().getInitialAppLink();
    } catch (e) {
      return null;
    }
  }

  Future<void> initAppLinks(Function(String) onBetInvite) async {
    try {
      // Get initial link if app was launched from link
      final uri = await getInitialLink();
      if (uri != null) {
        _handleAppLink(uri, onBetInvite);
      }

      // Listen for future app links while app is running
      uriLinkStream.listen((uri) {
        _handleAppLink(uri, onBetInvite);
      });
    } on PlatformException {
      // Handle errors
    }
  }

  void _handleAppLink(Uri uri, Function(String) onBetInvite) {
    if (uri.host == APP_HOST && uri.path == '/join') {
      final betId = uri.queryParameters['betId'];
      if (betId != null) {
        onBetInvite(betId);
      }
    }
  }
}