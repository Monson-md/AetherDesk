/// Result of a real check against GitHub Releases via
/// [AppUpdateService.checkForUpdate].
class AppUpdateInfo {
  const AppUpdateInfo({
    required this.latestVersion,
    required this.currentVersion,
    required this.isUpdateAvailable,
    required this.releaseUrl,
    required this.releaseNotes,
  });

  final String latestVersion;
  final String currentVersion;
  final bool isUpdateAvailable;
  final String releaseUrl;
  final String releaseNotes;
}
