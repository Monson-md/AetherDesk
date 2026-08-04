import 'package:aetherdesk/features/settings/domain/entities/app_settings.dart';
import 'package:aetherdesk/features/settings/domain/repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  const UpdateSettingsUseCase(this._repository);
  final SettingsRepository _repository;

  AppSettings call(AppSettings settings) =>
      _repository.updateSettings(settings);
}
