import 'dart:convert';

import 'package:aetherdesk/core/services/encryption/encryption_service.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Real AES-256-GCM implementation of [EncryptionService]. The key is
/// generated once and held in [FlutterSecureStorage] (Android Keystore /
/// iOS Keychain / Windows DPAPI / etc.) — never written in plain text
/// anywhere else. Each ciphertext is `base64(nonce ++ mac ++ box)`, unique
/// per call because a fresh random nonce is used every time.
class RealEncryptionService implements EncryptionService {
  RealEncryptionService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _keyStorageKey = 'aetherdesk_vault_master_key_v1';
  static final _algorithm = AesGcm.with256bits();

  final FlutterSecureStorage _secureStorage;
  SecretKey? _cachedKey;

  Future<SecretKey> _getOrCreateKey() async {
    final cached = _cachedKey;
    if (cached != null) return cached;

    final existing = await _secureStorage.read(key: _keyStorageKey);
    if (existing != null) {
      final key = SecretKey(base64Decode(existing));
      _cachedKey = key;
      return key;
    }

    final generated = await _algorithm.newSecretKey();
    final bytes = await generated.extractBytes();
    await _secureStorage.write(key: _keyStorageKey, value: base64Encode(bytes));
    _cachedKey = generated;
    return generated;
  }

  @override
  Future<String> encrypt(String plainText) async {
    if (plainText.isEmpty) return '';
    final key = await _getOrCreateKey();
    final secretBox = await _algorithm.encrypt(
      utf8.encode(plainText),
      secretKey: key,
    );
    return base64Encode(secretBox.concatenation());
  }

  @override
  Future<String> decrypt(String cipherText) async {
    if (cipherText.isEmpty) return '';
    final key = await _getOrCreateKey();
    final bytes = base64Decode(cipherText);
    final secretBox = SecretBox.fromConcatenation(
      bytes,
      nonceLength: _algorithm.nonceLength,
      macLength: _algorithm.macAlgorithm.macLength,
    );
    final clear = await _algorithm.decrypt(secretBox, secretKey: key);
    return utf8.decode(clear);
  }
}
