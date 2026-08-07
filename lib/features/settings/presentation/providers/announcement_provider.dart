import 'package:aetherdesk/core/services/firebase/remote_config/remote_config_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _announcementKey = 'announcement_message';

/// Fetches the real `announcement_message` Remote Config key so
/// `AppInfoSection` can show a server-driven banner without a full backend
/// — an empty/unset key (the default when nothing has been published from
/// the Firebase Console) means no banner.
final announcementProvider = FutureProvider<String?>((ref) async {
  final repository = ref.watch(remoteConfigRepositoryProvider);
  await repository.refresh();
  final value = repository.valueFor(_announcementKey);
  return value.isEmpty ? null : value;
});
