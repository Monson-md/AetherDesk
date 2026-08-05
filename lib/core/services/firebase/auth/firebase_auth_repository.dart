import 'package:aetherdesk/core/services/firebase/models/firebase_user.dart';

/// Feature-facing abstraction over [FirebaseAuthService] — modules should
/// depend on this, not the service directly, the same way a feature's
/// `domain/repositories/` contract depends on a `core/services/` provider
/// rather than a concrete SDK.
abstract interface class FirebaseAuthRepository {
  Stream<FirebaseUser?> authStateChanges();

  FirebaseUser? get currentUser;

  Future<FirebaseUser> signIn({
    required String email,
    required String password,
  });

  Future<FirebaseUser> signUp({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> resetPassword({required String email});
}
