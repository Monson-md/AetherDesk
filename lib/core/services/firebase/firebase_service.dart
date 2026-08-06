/// Contract for initializing the Firebase SDK (Auth, Firestore, Cloud
/// Messaging, Remote Config — Storage stays on the free Spark plan's
/// `NotConfiguredFirebaseStorageService` until the paid Blaze plan is
/// enabled).
///
/// `RealFirebaseService` is the real implementation: it calls
/// `Firebase.initializeApp()`, which reads its configuration from
/// `android/app/google-services.json` (added via the Google Services
/// Gradle plugin, see `android/app/build.gradle.kts`). `main.dart` awaits
/// [initialize] before `runApp` so every Firebase-backed provider
/// (`firebaseAuthServiceProvider`, `firestoreServiceProvider`, ...) has a
/// ready SDK by the time it's first read.
abstract interface class FirebaseService {
  Future<void> initialize();
}
