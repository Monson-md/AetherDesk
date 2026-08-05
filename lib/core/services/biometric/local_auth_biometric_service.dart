import 'package:aetherdesk/core/services/biometric/biometric_auth_service.dart';
import 'package:local_auth/local_auth.dart';

/// Real [BiometricAuthService] backed by `local_auth` (Android
/// BiometricPrompt, iOS Face ID/Touch ID, Windows Hello where supported).
class LocalAuthBiometricService implements BiometricAuthService {
  LocalAuthBiometricService({LocalAuthentication? localAuth})
    : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  @override
  Future<bool> isAvailable() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheckBiometrics || isDeviceSupported;
    } on LocalAuthException {
      return false;
    }
  }

  @override
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    }
  }
}
