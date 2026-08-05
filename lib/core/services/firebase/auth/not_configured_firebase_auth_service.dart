import 'package:aetherdesk/core/services/firebase/auth/firebase_auth_service.dart';
import 'package:aetherdesk/core/services/firebase/models/firebase_user.dart';

/// Default [FirebaseAuthService] wired in today — there is no Firebase
/// project connected, so every member either reports "nothing to report"
/// or throws, rather than silently pretending to succeed. Swap the
/// provider override in `firebase_auth_providers.dart` for a real
/// implementation once `firebase_auth` is added and configured.
class NotConfiguredFirebaseAuthService implements FirebaseAuthService {
  const NotConfiguredFirebaseAuthService();

  static const _unconfiguredMessage =
      'Firebase Auth is not configured yet — see '
      'core/services/firebase/firebase_service.dart for activation steps.';

  @override
  Stream<FirebaseUser?> authStateChanges() => Stream.value(null);

  @override
  FirebaseUser? get currentUser => null;

  @override
  Future<FirebaseUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) => throw UnimplementedError(_unconfiguredMessage);

  @override
  Future<FirebaseUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) => throw UnimplementedError(_unconfiguredMessage);

  @override
  Future<void> signOut() => throw UnimplementedError(_unconfiguredMessage);

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      throw UnimplementedError(_unconfiguredMessage);
}
