import 'package:aetherdesk/core/services/firebase/models/push_notification.dart';

/// Contract for push notifications (Firebase Cloud Messaging).
/// `RealNotificationService` is the real implementation, backed by the
/// `firebase_messaging` package.
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
