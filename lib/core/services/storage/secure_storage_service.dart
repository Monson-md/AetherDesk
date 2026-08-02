/// Contract for encrypted-at-rest storage: credentials, tokens, and
/// anything the future "Vault sécurisé" module needs to protect.
///
/// Kept separate from [LocalStorageService] on purpose — secure and
/// non-secure persistence have very different guarantees and should never
/// share an implementation. No concrete implementation yet (e.g. backed by
/// `flutter_secure_storage`) until the Vault module is actually built.
abstract interface class SecureStorageService {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}
