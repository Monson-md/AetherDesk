import 'package:aetherdesk/core/services/biometric/biometric_auth_service.dart';
import 'package:aetherdesk/core/services/biometric/local_auth_biometric_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return LocalAuthBiometricService();
});
