import 'package:aetherdesk/core/services/firebase/remote_config/real_remote_config_service.dart';
import 'package:aetherdesk/core/services/firebase/remote_config/remote_config_repository.dart';
import 'package:aetherdesk/core/services/firebase/remote_config/remote_config_repository_impl.dart';
import 'package:aetherdesk/core/services/firebase/remote_config/remote_config_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteConfigServiceProvider = Provider<RemoteConfigService>((ref) {
  return RealRemoteConfigService();
});

final remoteConfigRepositoryProvider = Provider<RemoteConfigRepository>((ref) {
  return RemoteConfigRepositoryImpl(ref.watch(remoteConfigServiceProvider));
});
