import 'package:aetherdesk/core/services/firebase/remote_config/remote_config_repository.dart';
import 'package:aetherdesk/core/services/firebase/remote_config/remote_config_service.dart';

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  const RemoteConfigRepositoryImpl(this._service);
  final RemoteConfigService _service;

  @override
  Future<void> refresh() => _service.fetchAndActivate();

  @override
  String valueFor(String key) => _service.getValue(key).stringValue;
}
