/// Mirrors the subset of `cloud_firestore`'s `DocumentSnapshot` that call
/// sites need, without depending on the `cloud_firestore` package (not
/// added yet — see `firebase_service.dart`).
class FirestoreDocument {
  const FirestoreDocument({
    required this.id,
    required this.collectionPath,
    required this.data,
  });

  final String id;
  final String collectionPath;
  final Map<String, dynamic> data;
}
