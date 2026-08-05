import 'package:aetherdesk/core/services/firebase/models/firebase_user.dart';

/// Contract for Firebase Authentication. Intentionally NOT implemented yet
/// — no `firebase_auth` dependency, no Firebase project configuration. See
/// `core/services/firebase/firebase_service.dart` for the activation steps.
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
