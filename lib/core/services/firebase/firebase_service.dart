/// Placeholder for future Firebase integration (Auth, Firestore, Analytics,
/// Crashlytics, Cloud Messaging...).
///
/// Intentionally NOT implemented yet: no `firebase_core` dependency has been
/// added to `pubspec.yaml`, and no `google-services.json` /
/// `GoogleService-Info.plist` exist. This class only reserves the shape of
/// the integration so that:
///   1. Feature modules can depend on an abstraction (`FirebaseService`)
///      instead of the Firebase SDK directly.
///   2. Wiring up real Firebase later means implementing this interface and
///      registering it as a Riverpod provider — no call sites change.
///
/// To activate later: add `firebase_core`, `firebase_auth`, `cloud_firestore`
/// (as needed), run `flutterfire configure`, then create a
/// `FirebaseServiceImpl implements FirebaseService` and swap the provider
/// override in `main.dart`.
abstract interface class FirebaseService {
  Future<void> initialize();
}
