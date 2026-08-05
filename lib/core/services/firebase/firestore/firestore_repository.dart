import 'package:aetherdesk/core/services/firebase/models/firestore_document.dart';

/// Feature-facing abstraction over [FirestoreService] — see
/// `FirebaseAuthRepository`'s doc comment for the same rationale.
abstract interface class FirestoreRepository {
  Future<FirestoreDocument?> fetchDocument(
    String collectionPath,
    String documentId,
  );

  Stream<FirestoreDocument?> watchDocument(
    String collectionPath,
    String documentId,
  );

  Future<List<FirestoreDocument>> fetchCollection(String collectionPath);

  Stream<List<FirestoreDocument>> watchCollection(String collectionPath);

  Future<String> create(String collectionPath, Map<String, dynamic> data);

  Future<void> save(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data, {
    bool merge = false,
  });

  Future<void> remove(String collectionPath, String documentId);
}
