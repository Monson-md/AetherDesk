import 'package:aetherdesk/core/services/firebase/auth/firebase_auth_repository.dart';
import 'package:aetherdesk/core/services/firebase/auth/firebase_auth_service.dart';
import 'package:aetherdesk/core/services/firebase/models/firebase_user.dart';

class FirebaseAuthRepositoryImpl implements FirebaseAuthRepository {
  const FirebaseAuthRepositoryImpl(this._service);
  final FirebaseAuthService _service;

  @override
  Stream<FirebaseUser?> authStateChanges() => _service.authStateChanges();

  @override
  FirebaseUser? get currentUser => _service.currentUser;

  @override
  Future<FirebaseUser> signIn({
    required String email,
    required String password,
  }) => _service.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<FirebaseUser> signUp({
    required String email,
    required String password,
  }) =>
      _service.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> signOut() => _service.signOut();

  @override
  Future<void> resetPassword({required String email}) =>
      _service.sendPasswordResetEmail(email: email);
}
