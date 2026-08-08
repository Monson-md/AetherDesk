/// Contract for measuring and reclaiming the app's own on-disk footprint —
/// used by `settings/presentation/widgets/storage_section.dart`.
///
/// This intentionally doesn't try to match Android's system-wide per-app
/// storage figure (that also counts shared_preferences/secure-storage
/// files not exposed by `path_provider`, and would need a platform
/// channel) — it reports the real byte size of the app's own managed
/// files/cache directories instead.
abstract interface class AppStorageUsageService {
  Future<int> calculateUsageBytes();

  /// Deletes everything in the app's temporary/cache directory.
  Future<void> clearCache();
}
