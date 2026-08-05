/// Mirrors the subset of `firebase_auth`'s `User` that call sites need,
/// without depending on the `firebase_auth` package (not added yet — see
/// `firebase_service.dart`).
class FirebaseUser {
  const FirebaseUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.isEmailVerified,
  });

  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;
}
