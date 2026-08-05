import 'dart:convert';

import 'package:aetherdesk/core/services/encryption/encryption_service.dart';

/// Placeholder [EncryptionService]: a reversible XOR-then-base64 transform,
/// NOT real cryptography — there is no secret key management, no salt, no
/// authenticated encryption. It exists purely so callers (e.g.
/// `secure_vault`) can be written against the "encrypted at rest" shape
/// today and swapped to a real algorithm later without touching their own
/// code, mirroring `SimulatedAiService`/`SimulatedSyntaxHighlighter`.
class SimulatedEncryptionService implements EncryptionService {
  const SimulatedEncryptionService();

  static const _obfuscationKey = 'aetherdesk-simulated-key';

  @override
  String encrypt(String plainText) {
    if (plainText.isEmpty) return plainText;
    return base64Encode(_xor(utf8.encode(plainText)));
  }

  @override
  String decrypt(String cipherText) {
    if (cipherText.isEmpty) return cipherText;
    return utf8.decode(_xor(base64Decode(cipherText)));
  }

  List<int> _xor(List<int> bytes) {
    final keyBytes = utf8.encode(_obfuscationKey);
    return [
      for (var i = 0; i < bytes.length; i++)
        bytes[i] ^ keyBytes[i % keyBytes.length],
    ];
  }
}
