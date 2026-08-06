import 'package:aetherdesk/core/services/firebase/models/remote_config_value.dart';
import 'package:aetherdesk/core/services/firebase/remote_config/remote_config_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart' as rc;

/// Real [RemoteConfigService] backed by `firebase_remote_config`.
class RealRemoteConfigService implements RemoteConfigService {
  RealRemoteConfigService({rc.FirebaseRemoteConfig? remoteConfig})
    : _remoteConfig = remoteConfig ?? rc.FirebaseRemoteConfig.instance;

  final rc.FirebaseRemoteConfig _remoteConfig;

  RemoteConfigValueSource _toSource(rc.ValueSource source) => switch (source) {
    rc.ValueSource.valueStatic => RemoteConfigValueSource.staticValue,
    rc.ValueSource.valueDefault => RemoteConfigValueSource.defaultValue,
    rc.ValueSource.valueRemote => RemoteConfigValueSource.remote,
  };

  @override
  Future<void> fetchAndActivate() async {
    await _remoteConfig.fetchAndActivate();
  }

  @override
  RemoteConfigValue getValue(String key) {
    final value = _remoteConfig.getValue(key);
    return RemoteConfigValue(
      key: key,
      stringValue: value.asString(),
      source: _toSource(value.source),
    );
  }

  @override
  Map<String, RemoteConfigValue> getAll() {
    return _remoteConfig.getAll().map(
      (key, value) => MapEntry(
        key,
        RemoteConfigValue(
          key: key,
          stringValue: value.asString(),
          source: _toSource(value.source),
        ),
      ),
    );
  }
}
