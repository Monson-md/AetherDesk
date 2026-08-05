import 'package:aetherdesk/core/services/firebase/models/push_notification.dart';

/// Contract for push notifications (Firebase Cloud Messaging).
/// Intentionally NOT implemented yet — no `firebase_messaging` dependency,
/// no Firebase project configuration. See
/// `core/services/firebase/firebase_service.dart` for activation steps.
///
/// Purely remote push, unrelated to `settings`' local notification
/// preference toggles (`AppSettings.notificationsEnabled`), which will
/// gate whether this service is even asked to do anything once it's real.
abstract interface class NotificationService {
  Future<String?> getDeviceToken();

  Future<bool> requestPermission();

  Stream<PushNotification> onMessageReceived();

  Future<void> subscribeToTopic(String topic);

  Future<void> unsubscribeFromTopic(String topic);
}
