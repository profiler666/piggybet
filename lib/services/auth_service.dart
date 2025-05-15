import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user (anonymous or signed in)
  User? get currentUser => _auth.currentUser;

  // Check if user is anonymous
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? true;

  // Ensure user is authenticated (anonymously if needed)
  Future<User?> ensureAuthenticated() async {
    try {
      if (currentUser != null) {
        return currentUser;
      }
      // This requires Anonymous auth to be enabled in Firebase Console
      final result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      throw Exception('Failed to authenticate: $e');
    }
  }

  // Sign in anonymously
  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      throw Exception('Failed to sign in anonymously: $e');
    }
  }

  // Upgrade anonymous account to Google sign in
  Future<UserCredential> upgradeAnonymous() async {
    if (!_auth.currentUser!.isAnonymous) {
      throw Exception('User is not anonymous');
    }

    try {
      // Get Google credentials
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Link anonymous account with Google credentials
      return await _auth.currentUser!.linkWithCredential(credential);
    } catch (e) {
      throw Exception('Failed to upgrade anonymous account: $e');
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Auto sign in anonymously after sign out
      await signInAnonymously();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}