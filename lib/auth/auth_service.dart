import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  bool get isGuest => _auth.currentUser?.isAnonymous ?? false;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Google Sign In ──
  Future<AuthResult> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return AuthResult.cancelled();

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // If currently a guest, link account instead of creating new
      if (isGuest) {
        return await _linkGuestWithGoogle(credential);
      }

      final result = await _auth.signInWithCredential(credential);
      await _createOrUpdateUserProfile(result.user!);
      return AuthResult.success(result.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(e.message ?? 'Google sign in failed');
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  // ── Guest / Anonymous Mode ──
  Future<AuthResult> signInAsGuest() async {
    try {
      final result = await _auth.signInAnonymously();
      return AuthResult.success(result.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.error(e.message ?? 'Guest sign in failed');
    }
  }

  // ── Link Guest → Google (No data loss) ──
  Future<AuthResult> _linkGuestWithGoogle(OAuthCredential credential) async {
    try {
      final result = await _auth.currentUser!.linkWithCredential(credential);
      await _createOrUpdateUserProfile(result.user!);
      return AuthResult.success(result.user!, wasLinked: true);
    } on FirebaseAuthException catch (e) {
      // Account already exists — sign in and merge
      if (e.code == 'credential-already-in-use') {
        final result = await _auth.signInWithCredential(credential);
        await _createOrUpdateUserProfile(result.user!);
        return AuthResult.success(result.user!, wasLinked: true);
      }
      return AuthResult.error(e.message ?? 'Account linking failed');
    }
  }

  // ── Sign Out ──
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // ── Delete Account ──
  Future<AuthResult> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return AuthResult.error('No user logged in');

      // Delete all Firestore data first
      await _deleteAllUserData(user.uid);

      // Delete Firebase Auth account
      await user.delete();
      return AuthResult.success(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return AuthResult.error('Please sign out and sign in again, then try deleting.');
      }
      return AuthResult.error(e.message ?? 'Delete failed');
    }
  }

  // ── Create / Update Firestore Profile ──
  Future<void> _createOrUpdateUserProfile(User user) async {
    final docRef = _db.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final prefs = await SharedPreferences.getInstance();
      await docRef.set({
        'uid': user.uid,
        'name': user.displayName ?? 'NitePlanner',
        'email': user.email ?? '',
        'isGuest': user.isAnonymous,
        'joinDate': DayHelper.todayString(),
        'primaryGoal': prefs.getString('primary_goal') ?? 'general',
        'mainStruggle': prefs.getString('main_struggle') ?? 'consistency',
        'currentDisciplineScore': 0.0,
        'streak': 0,
        'totalTasksCompleted': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.update({
        'name': user.displayName ?? doc['name'],
        'email': user.email ?? doc['email'],
        'isGuest': user.isAnonymous,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // ── Delete all user data from Firestore ──
  Future<void> _deleteAllUserData(String uid) async {
    final collections = ['tasks', 'reflections', 'discipline_scores', 'future_letters'];
    for (final col in collections) {
      final snapshot = await _db.collection('users/$uid/$col').get();
      final batch = _db.batch();
      for (final doc in snapshot.docs) { batch.delete(doc.reference); }
      await batch.commit();
    }
    await _db.collection('users').doc(uid).delete();
  }

  // ── Update profile score ──
  Future<void> updateDisciplineScore(double score, int streak, int completed) async {
    final user = currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).update({
      'currentDisciplineScore': score,
      'streak': streak,
      'totalTasksCompleted': completed,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

// ── Auth Result wrapper ──
class AuthResult {
  final User? user;
  final String? error;
  final bool cancelled;
  final bool wasLinked;

  AuthResult._({this.user, this.error, this.cancelled = false, this.wasLinked = false});

  factory AuthResult.success(User? user, {bool wasLinked = false}) =>
      AuthResult._(user: user, wasLinked: wasLinked);
  factory AuthResult.error(String msg) => AuthResult._(error: msg);
  factory AuthResult.cancelled() => AuthResult._(cancelled: true);

  bool get isSuccess => error == null && !cancelled;
}

class DayHelper {
  static String todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
