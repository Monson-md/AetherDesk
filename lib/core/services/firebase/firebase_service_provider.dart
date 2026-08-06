import 'package:aetherdesk/core/services/firebase/firebase_service.dart';
import 'package:aetherdesk/core/services/firebase/real_firebase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseServiceProvider = Provider<FirebaseService>(
  (ref) => const RealFirebaseService(),
);
