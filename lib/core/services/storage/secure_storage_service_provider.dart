import 'package:aetherdesk/core/services/storage/secure_storage_service.dart';
import 'package:aetherdesk/core/services/storage/secure_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single place to swap [SecureStorageService] for a different backing
/// implementation later; every consumer depends on the interface only.
final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => const SecureStorageServiceImpl(),
);
