import 'package:aetherdesk/core/services/firebase/models/firebase_user.dart';

/// Contract for Firebase Authentication. `RealFirebaseAuthService` is the
/// real implementation, backed by the `firebase_auth` package and the
/// Firebase project configured via `android/app/google-services.json`.
abstract interface class FirebaseAuthService {
  Stream<FirebaseUser?> authStateChanges();

  FirebaseUser? get currentUser;

  Future<FirebaseUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<FirebaseUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({required String email});
}
