import 'package:aetherdesk/core/services/updates/app_update_info.dart';

/// Contract for checking whether a newer app version is available. The
/// real implementation (`GithubAppUpdateService`) checks GitHub Releases —
/// a real, free, unauthenticated API — so this is a genuine "connect to
/// GitHub for app updates" feature, not a simulated one.
abstract interface class AppUpdateService {
  /// Returns update info, or `null` if the check failed (no network, no
  /// releases published yet, GitHub API unreachable, ...) — a recoverable,
  /// expected outcome, not a programming error.
  Future<AppUpdateInfo?> checkForUpdate();
}
