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
    this.aiEndpointUrl,
    this.aiModel,
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

  /// Base URL of a real, user-chosen OpenAI-compatible `/chat/completions`
  /// API (self-hosted Ollama/LM Studio, OpenRouter, etc.) — `null`/empty
  /// means `ai_assistant` keeps using `SimulatedAiService` (see
  /// `aiAssistantRepositoryProvider`).
  final String? aiEndpointUrl;

  /// Model name sent in the request body to [aiEndpointUrl].
  final String? aiModel;
  final DateTime? lastBackupAt;

  AppSettings copyWith({
    String? displayName,
    bool? notificationsEnabled,
    bool? notificationSoundEnabled,
    bool? biometricLockEnabled,
    bool? analyticsEnabled,
    String? aiApiKey,
    bool clearAiApiKey = false,
    String? aiEndpointUrl,
    bool clearAiEndpointUrl = false,
    String? aiModel,
    bool clearAiModel = false,
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
      aiEndpointUrl: clearAiEndpointUrl
          ? null
          : (aiEndpointUrl ?? this.aiEndpointUrl),
      aiModel: clearAiModel ? null : (aiModel ?? this.aiModel),
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    );
  }
}
