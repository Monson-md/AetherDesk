import 'package:aetherdesk/features/settings/domain/entities/app_settings.dart';
import 'package:aetherdesk/features/settings/domain/repositories/settings_repository.dart';

/// In-memory implementation of [SettingsRepository] — no disk I/O. A future
/// implementation backed by `core/services/storage/local_storage_service.dart`
/// can replace this file without any change to `domain/` or `presentation/`.
class SettingsRepositoryImpl implements SettingsRepository {
  AppSettings _settings = AppSettings.initial();

  @override
  AppSettings getSettings() => _settings;

  @override
  AppSettings updateSettings(AppSettings settings) {
    _settings = settings;
    return _settings;
  }
}
