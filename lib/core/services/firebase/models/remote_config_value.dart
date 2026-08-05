/// Where a [RemoteConfigValue] actually came from — mirrors
/// `firebase_remote_config`'s `ValueSource` without depending on that
/// package (not added yet — see `firebase_service.dart`).
enum RemoteConfigValueSource { staticValue, defaultValue, remote }

class RemoteConfigValue {
  const RemoteConfigValue({
    required this.key,
    required this.stringValue,
    required this.source,
  });

  final String key;
  final String stringValue;
  final RemoteConfigValueSource source;
}
