import 'package:aetherdesk/core/services/firebase/auth/firebase_auth_repository.dart';
import 'package:aetherdesk/core/services/firebase/auth/firebase_auth_repository_impl.dart';
import 'package:aetherdesk/core/services/firebase/auth/firebase_auth_service.dart';
import 'package:aetherdesk/core/services/firebase/auth/real_firebase_auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return RealFirebaseAuthService();
});

final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  return FirebaseAuthRepositoryImpl(ref.watch(firebaseAuthServiceProvider));
});
