import 'package:aetherdesk/core/services/storage/app_storage_usage_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Real, on-demand byte count of the app's own documents/support/temporary
/// directories — refetched via `ref.invalidate` after a real "Clear cache".
final storageUsageBytesProvider = FutureProvider<int>((ref) {
  return ref.watch(appStorageUsageServiceProvider).calculateUsageBytes();
});
