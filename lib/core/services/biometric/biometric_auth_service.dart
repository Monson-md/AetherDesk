/// Contract for gating access with the device's biometric/PIN unlock (e.g.
/// before revealing `secure_vault` contents). Mirrors the shape of the
/// other `core/services/` contracts — a single seam so the concrete
/// implementation (`LocalAuthBiometricService`) can change without
/// touching `domain/` or `presentation/` in any module.
///
/// `features/secure_vault` gates its home page behind [authenticate] when
/// [isAvailable] reports hardware support — see
/// `secure_vault_home_page.dart`.
abstract interface class BiometricAuthService {
  /// Whether the device reports biometric/PIN hardware available for use.
  Future<bool> isAvailable();

  /// Prompts for biometric/PIN confirmation with [reason] as the shown
  /// message, resolving to whether it succeeded.
  Future<bool> authenticate({required String reason});
}
