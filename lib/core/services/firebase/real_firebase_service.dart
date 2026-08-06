import 'package:aetherdesk/core/services/firebase/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart' hide FirebaseService;

/// Real [FirebaseService]: initializes the Firebase SDK from the native
/// config file (`android/app/google-services.json`) — no explicit
/// `FirebaseOptions` needed since this app is Android-only for Firebase
/// purposes. Requires `google-services.json` to exist and the Google
/// Services Gradle plugin to be applied (see `android/app/build.gradle.kts`
/// and `android/build.gradle.kts`).
class RealFirebaseService implements FirebaseService {
  const RealFirebaseService();

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();
  }
}
