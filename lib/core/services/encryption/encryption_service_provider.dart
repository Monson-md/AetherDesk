import 'package:aetherdesk/core/services/encryption/encryption_service.dart';
import 'package:aetherdesk/core/services/encryption/real_encryption_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single place to swap the encryption implementation later (e.g. a
/// hardware-backed key store): change what this provider returns and every
/// consumer — currently `features/secure_vault` — picks up the change.
final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return RealEncryptionService();
});
