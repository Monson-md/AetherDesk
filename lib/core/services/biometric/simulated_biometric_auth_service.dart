import 'package:aetherdesk/core/services/biometric/biometric_auth_service.dart';

/// Local, hardware-free stand-in for [BiometricAuthService]. Reports no
/// hardware available and never prompts — this app must never require
/// GitHub, biometrics, or any other gate just to be opened (see the
/// removed GitHub Device Flow login screen). Once a real `local_auth`
/// implementation lands, callers (e.g. an optional "lock secure_vault"
/// setting) don't change.
class SimulatedBiometricAuthService implements BiometricAuthService {
  const SimulatedBiometricAuthService();

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<bool> authenticate({required String reason}) async => false;
}
