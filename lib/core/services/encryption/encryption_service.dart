/// Contract for turning a secret plain-text value into an opaque
/// ciphertext and back, so a module can hold "encrypted at rest" data
/// without depending on any specific cryptography implementation. This is
/// the swap point: `RealEncryptionService` implements real AES-256-GCM
/// (via the `cryptography` package) with its key held in
/// `flutter_secure_storage` — async because both of those are.
abstract interface class EncryptionService {
  Future<String> encrypt(String plainText);

  Future<String> decrypt(String cipherText);
}
