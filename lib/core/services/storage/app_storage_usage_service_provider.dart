import 'package:aetherdesk/core/services/storage/app_storage_usage_service.dart';
import 'package:aetherdesk/core/services/storage/real_app_storage_usage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appStorageUsageServiceProvider = Provider<AppStorageUsageService>(
  (ref) => const RealAppStorageUsageService(),
);
