/// The whole bundle of local, non-backed-up user preferences owned by the
/// `settings` module. Theme, language and text scale are deliberately
/// **not** here — those are cross-cutting concerns already exposed as their
/// own providers in `core/theme/` and `core/localization/`, which this
/// module's presentation layer reads/writes directly (see
/// `appearance_section.dart`) rather than duplicating through this entity.
class AppSettings {
  const AppSettings({
    required this.displayName,
    required this.notificationsEnabled,
    required this.notificationSoundEnabled,
    required this.biometricLockEnabled,
    required this.analyticsEnabled,
    this.aiApiKey,
    this.lastBackupAt,
  });

  factory AppSettings.initial() => const AppSettings(
    displayName: '',
    notificationsEnabled: true,
    notificationSoundEnabled: true,
    biometricLockEnabled: false,
    analyticsEnabled: false,
  );

  final String displayName;
  final bool notificationsEnabled;
  final bool notificationSoundEnabled;
  final bool biometricLockEnabled;
  final bool analyticsEnabled;

  /// Kept in memory only, never persisted or logged — there is no secure
  /// storage backing this module yet (see `CLAUDE.md`/`PROJECT_STATUS.md`
  /// on `flutter_secure_storage` being removed with the GitHub auth step
  /// and slated to come back for exactly this use case).
  final String? aiApiKey;
  final DateTime? lastBackupAt;

  AppSettings copyWith({
    String? displayName,
    bool? notificationsEnabled,
    bool? notificationSoundEnabled,
    bool? biometricLockEnabled,
    bool? analyticsEnabled,
    String? aiApiKey,
    bool clearAiApiKey = false,
    DateTime? lastBackupAt,
  }) {
    return AppSettings(
      displayName: displayName ?? this.displayName,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationSoundEnabled:
          notificationSoundEnabled ?? this.notificationSoundEnabled,
      biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      aiApiKey: clearAiApiKey ? null : (aiApiKey ?? this.aiApiKey),
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    );
  }
}
