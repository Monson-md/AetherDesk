import 'package:aetherdesk/core/services/biometric/biometric_auth_service.dart';
import 'package:aetherdesk/core/services/biometric/simulated_biometric_auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return const SimulatedBiometricAuthService();
});
