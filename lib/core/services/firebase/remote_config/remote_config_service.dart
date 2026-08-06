import 'package:aetherdesk/core/services/firebase/models/remote_config_value.dart';

/// Contract for Firebase Remote Config. `RealRemoteConfigService` is the
/// real implementation, backed by the `firebase_remote_config` package.
abstract interface class RemoteConfigService {
  Future<void> fetchAndActivate();

  RemoteConfigValue getValue(String key);

  Map<String, RemoteConfigValue> getAll();
}
