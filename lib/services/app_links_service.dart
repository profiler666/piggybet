import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';

class AppLinksService {
  static const String APP_SCHEME = 'piggybet';
  static const String APP_HOST = 'app.piggybet.com';

  Future<String> createInviteLink(String betId) async {
    // Create a deep link in the format: piggybet://app.piggybet.com/join?betId=xyz
    return '$APP_SCHEME://$APP_HOST/join?betId=$betId';
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