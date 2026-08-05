import 'package:aetherdesk/core/services/firebase/models/push_notification.dart';
import 'package:aetherdesk/core/services/firebase/notifications/notification_service.dart';

/// Default [NotificationService] wired in today — see
/// `NotConfiguredFirebaseAuthService`'s doc comment for the same rationale.
class NotConfiguredNotificationService implements NotificationService {
  const NotConfiguredNotificationService();

  @override
  Future<String?> getDeviceToken() async => null;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Stream<PushNotification> onMessageReceived() => const Stream.empty();

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Future<void> unsubscribeFromTopic(String topic) async {}
}
