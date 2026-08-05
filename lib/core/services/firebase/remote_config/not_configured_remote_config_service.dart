import 'package:aetherdesk/core/services/firebase/models/remote_config_value.dart';
import 'package:aetherdesk/core/services/firebase/remote_config/remote_config_service.dart';

/// Default [RemoteConfigService] wired in today — see
/// `NotConfiguredFirebaseAuthService`'s doc comment for the same rationale.
/// Unlike the other stubs, every value simply reports its
/// [RemoteConfigValueSource.defaultValue] as an empty string rather than
/// throwing, since reading a missing config key is an expected, recoverable
/// case for real callers — not a programming error.
class NotConfiguredRemoteConfigService implements RemoteConfigService {
  const NotConfiguredRemoteConfigService();

  @override
  Future<void> fetchAndActivate() async {}

  @override
  RemoteConfigValue getValue(String key) => RemoteConfigValue(
    key: key,
    stringValue: '',
    source: RemoteConfigValueSource.defaultValue,
  );

  @override
  Map<String, RemoteConfigValue> getAll() => const {};
}
