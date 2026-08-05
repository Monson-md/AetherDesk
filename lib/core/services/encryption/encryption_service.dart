/// Contract for turning a secret plain-text value into an opaque
/// ciphertext and back, so a module can hold "encrypted at rest" data
/// without depending on any specific cryptography implementation. This is
/// the swap point: today's implementation
/// (`SimulatedEncryptionService`) is a reversible placeholder, not real
/// cryptography — a later implementation backed by a real algorithm (e.g.
/// AES via the `cryptography` package) plus a securely-stored key can
/// replace it without any change to `domain/`.
abstract interface class EncryptionService {
  String encrypt(String plainText);

  String decrypt(String cipherText);
}
