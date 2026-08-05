import 'package:aetherdesk/core/services/firebase/storage/firebase_storage_repository.dart';
import 'package:aetherdesk/core/services/firebase/storage/firebase_storage_repository_impl.dart';
import 'package:aetherdesk/core/services/firebase/storage/firebase_storage_service.dart';
import 'package:aetherdesk/core/services/firebase/storage/not_configured_firebase_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageServiceProvider = Provider<FirebaseStorageService>((ref) {
  return const NotConfiguredFirebaseStorageService();
});

final firebaseStorageRepositoryProvider = Provider<FirebaseStorageRepository>((
  ref,
) {
  return FirebaseStorageRepositoryImpl(
    ref.watch(firebaseStorageServiceProvider),
  );
});
