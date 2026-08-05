/// Mirrors the subset of `firebase_messaging`'s `RemoteMessage` that call
/// sites need, without depending on the `firebase_messaging` package (not
/// added yet — see `firebase_service.dart`).
class PushNotification {
  const PushNotification({
    required this.id,
    required this.title,
    required this.body,
    this.data = const {},
    required this.receivedAt,
  });

  final String id;
  final String title;
  final String body;
  final Map<String, String> data;
  final DateTime receivedAt;
}
