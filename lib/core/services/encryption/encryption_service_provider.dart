import 'package:aetherdesk/core/services/encryption/encryption_service.dart';
import 'package:aetherdesk/core/services/encryption/simulated_encryption_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  return const SimulatedEncryptionService();
});
