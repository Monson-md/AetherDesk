import 'package:aetherdesk/core/services/firebase/auth/firebase_auth_service.dart';
import 'package:aetherdesk/core/services/firebase/models/firebase_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

/// Real [FirebaseAuthService] backed by `firebase_auth`.
class RealFirebaseAuthService implements FirebaseAuthService {
  RealFirebaseAuthService({fb.FirebaseAuth? auth})
    : _auth = auth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  FirebaseUser _toFirebaseUser(fb.User user) => FirebaseUser(
    uid: user.uid,
    email: user.email,
    displayName: user.displayName,
    photoUrl: user.photoURL,
    isEmailVerified: user.emailVerified,
  );

  @override
  Stream<FirebaseUser?> authStateChanges() => _auth.authStateChanges().map(
    (user) => user == null ? null : _toFirebaseUser(user),
  );

  @override
  FirebaseUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : _toFirebaseUser(user);
  }

  @override
  Future<FirebaseUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Sign-in succeeded but no user was returned.');
    }
    return _toFirebaseUser(user);
  }

  @override
  Future<FirebaseUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Account creation succeeded but no user was returned.');
    }
    return _toFirebaseUser(user);
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      _auth.sendPasswordResetEmail(email: email);
}
