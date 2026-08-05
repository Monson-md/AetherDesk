/// Feature-facing abstraction over [RemoteConfigService] — see
/// `FirebaseAuthRepository`'s doc comment for the same rationale.
abstract interface class RemoteConfigRepository {
  Future<void> refresh();

  String valueFor(String key);
}
