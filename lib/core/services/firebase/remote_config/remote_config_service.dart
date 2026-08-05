import 'package:aetherdesk/core/services/firebase/models/remote_config_value.dart';

/// Contract for Firebase Remote Config. Intentionally NOT implemented yet
/// — no `firebase_remote_config` dependency, no Firebase project
/// configuration. See `core/services/firebase/firebase_service.dart` for
/// activation steps.
abstract interface class RemoteConfigService {
  Future<void> fetchAndActivate();

  RemoteConfigValue getValue(String key);

  Map<String, RemoteConfigValue> getAll();
}
