import 'package:aetherdesk/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:aetherdesk/features/settings/domain/repositories/settings_repository.dart';
import 'package:aetherdesk/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:aetherdesk/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl();
});

final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  return GetSettingsUseCase(ref.watch(settingsRepositoryProvider));
});

final updateSettingsUseCaseProvider = Provider<UpdateSettingsUseCase>((ref) {
  return UpdateSettingsUseCase(ref.watch(settingsRepositoryProvider));
});
