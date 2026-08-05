import 'package:aetherdesk/core/services/firebase/models/push_notification.dart';

/// Feature-facing abstraction over [NotificationService] — see
/// `FirebaseAuthRepository`'s doc comment for the same rationale.
abstract interface class NotificationRepository {
  Future<bool> requestPermission();

  Stream<PushNotification> messages();

  Future<void> subscribeToTopic(String topic);

  Future<void> unsubscribeFromTopic(String topic);
}
