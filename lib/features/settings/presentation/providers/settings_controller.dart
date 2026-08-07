import 'package:aetherdesk/features/settings/domain/entities/app_settings.dart';
import 'package:aetherdesk/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen state for the `settings` module: a single [AppSettings] bundle,
/// always written back through [UpdateSettingsUseCase] as a whole rather
/// than field-by-field usecases — there's no nested/relational data here
/// (unlike `project_management`/`secure_vault`), just a flat preferences
/// object, so one full-replace action is enough.
class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(getSettingsUseCaseProvider).call();

  void setDisplayName(String displayName) {
    _save(state.copyWith(displayName: displayName));
  }

  void setNotificationsEnabled(bool value) {
    _save(state.copyWith(notificationsEnabled: value));
  }

  void setNotificationSoundEnabled(bool value) {
    _save(state.copyWith(notificationSoundEnabled: value));
  }

  void setBiometricLockEnabled(bool value) {
    _save(state.copyWith(biometricLockEnabled: value));
  }

  void setAnalyticsEnabled(bool value) {
    _save(state.copyWith(analyticsEnabled: value));
  }

  void setAiApiKey(String? apiKey) {
    final trimmed = apiKey?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      _save(state.copyWith(clearAiApiKey: true));
    } else {
      _save(state.copyWith(aiApiKey: trimmed));
    }
  }

  /// Stamps [AppSettings.lastBackupAt] after a real `CloudBackupController`
  /// backup succeeds — see `BackupSection`.
  void markBackedUpNow() {
    _save(state.copyWith(lastBackupAt: DateTime.now()));
  }

  void _save(AppSettings settings) {
    state = ref.read(updateSettingsUseCaseProvider).call(settings);
  }
}

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
