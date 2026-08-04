import 'package:aetherdesk/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  AppSettings getSettings();

  AppSettings updateSettings(AppSettings settings);
}
