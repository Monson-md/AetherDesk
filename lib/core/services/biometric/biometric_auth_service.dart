/// Contract for gating access with the device's biometric/PIN unlock (e.g.
/// before revealing `secure_vault` contents). Mirrors the shape of the
/// other `core/services/` contracts — a single seam meant to be swapped for
/// a real implementation (`local_auth` or similar) without touching
/// `domain/` or `presentation/` in any module.
///
/// No module wires this into a mandatory gate yet — see
/// `simulated_biometric_auth_service.dart` for why.
abstract interface class BiometricAuthService {
  /// Whether the device reports biometric/PIN hardware available for use.
  Future<bool> isAvailable();

  /// Prompts for biometric/PIN confirmation with [reason] as the shown
  /// message, resolving to whether it succeeded.
  Future<bool> authenticate({required String reason});
}
