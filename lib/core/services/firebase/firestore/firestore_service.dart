import 'package:aetherdesk/core/services/firebase/models/firestore_document.dart';

/// Contract for Cloud Firestore. `RealFirestoreService` is the real
/// implementation, backed by the `cloud_firestore` package.
abstract interface class FirestoreService {
  Future<FirestoreDocument?> getDocument({
    required String collectionPath,
    required String documentId,
  });

  Stream<FirestoreDocument?> watchDocument({
    required String collectionPath,
    required String documentId,
  });

  Future<List<FirestoreDocument>> getCollection({
    required String collectionPath,
  });

  Stream<List<FirestoreDocument>> watchCollection({
    required String collectionPath,
  });

  Future<String> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  });

  Future<void> setDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = false,
  });

  Future<void> deleteDocument({
    required String collectionPath,
    required String documentId,
  });
}
