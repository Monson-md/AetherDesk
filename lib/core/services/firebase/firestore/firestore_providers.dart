import 'package:aetherdesk/core/services/firebase/firestore/firestore_repository.dart';
import 'package:aetherdesk/core/services/firebase/firestore/firestore_repository_impl.dart';
import 'package:aetherdesk/core/services/firebase/firestore/firestore_service.dart';
import 'package:aetherdesk/core/services/firebase/firestore/not_configured_firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return const NotConfiguredFirestoreService();
});

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepositoryImpl(ref.watch(firestoreServiceProvider));
});
