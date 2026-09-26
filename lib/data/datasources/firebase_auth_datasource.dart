import 'package:firebase_auth/firebase_auth.dart' as fb;

/// Thin wrapper over FirebaseAuth so the repository layer never imports
/// the firebase_auth package directly (keeps data layer swappable/testable).
class FirebaseAuthDataSource {
  FirebaseAuthDataSource(this._auth);
  final fb.FirebaseAuth _auth;

  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  fb.User? get currentUser => _auth.currentUser;

  Future<fb.User> signInAnonymously() async {
    final cred = await _auth.signInAnonymously();
    final user = cred.user;
    if (user == null) throw StateError('Anonymous sign-in returned null user');
    return user;
  }

  Future<fb.User> signInWithEmail({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = cred.user;
    if (user == null) throw StateError('Email sign-in returned null user');
    return user;
  }

  Future<fb.User> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final user = cred.user;
    if (user == null) throw StateError('Registration returned null user');
    await user.updateDisplayName(displayName);
    return user;
  }

  Future<void> signOut() => _auth.signOut();
}
