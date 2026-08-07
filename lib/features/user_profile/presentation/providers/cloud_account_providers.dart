import 'package:aetherdesk/core/services/firebase/auth/firebase_auth_providers.dart';
import 'package:aetherdesk/core/services/firebase/models/firebase_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Real Firebase Auth state — `null` when signed out. Signing in is
/// entirely optional: see [UserProfile]'s doc comment for why the app stays
/// fully usable without it.
final cloudAuthStateProvider = StreamProvider<FirebaseUser?>((ref) {
  return ref.watch(firebaseAuthRepositoryProvider).authStateChanges();
});

/// Drives the sign-in/sign-up/sign-out/reset-password actions of
/// `CloudAccountSection`, surfacing loading/error state so the widget stays
/// a thin presentation layer.
class CloudAccountController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool> signIn({required String email, required String password}) =>
      _run(
        () async => ref
            .read(firebaseAuthRepositoryProvider)
            .signIn(email: email, password: password),
      );

  Future<bool> signUp({required String email, required String password}) =>
      _run(
        () async => ref
            .read(firebaseAuthRepositoryProvider)
            .signUp(email: email, password: password),
      );

  Future<bool> signOut() =>
      _run(() => ref.read(firebaseAuthRepositoryProvider).signOut());

  Future<bool> resetPassword({required String email}) => _run(
    () => ref.read(firebaseAuthRepositoryProvider).resetPassword(email: email),
  );

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } on Exception catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}

final cloudAccountControllerProvider =
    NotifierProvider<CloudAccountController, AsyncValue<void>>(
      CloudAccountController.new,
    );
