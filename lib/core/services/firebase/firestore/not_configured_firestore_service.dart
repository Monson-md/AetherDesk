import 'package:aetherdesk/core/services/firebase/firestore/firestore_service.dart';
import 'package:aetherdesk/core/services/firebase/models/firestore_document.dart';

/// Default [FirestoreService] wired in today — see
/// `NotConfiguredFirebaseAuthService`'s doc comment for the same rationale.
class NotConfiguredFirestoreService implements FirestoreService {
  const NotConfiguredFirestoreService();

  static const _unconfiguredMessage =
      'Cloud Firestore is not configured yet — see '
      'core/services/firebase/firebase_service.dart for activation steps.';

  @override
  Future<FirestoreDocument?> getDocument({
    required String collectionPath,
    required String documentId,
  }) => throw UnimplementedError(_unconfiguredMessage);

  @override
  Stream<FirestoreDocument?> watchDocument({
    required String collectionPath,
    required String documentId,
  }) => Stream.value(null);

  @override
  Future<List<FirestoreDocument>> getCollection({
    required String collectionPath,
  }) => throw UnimplementedError(_unconfiguredMessage);

  @override
  Stream<List<FirestoreDocument>> watchCollection({
    required String collectionPath,
  }) => Stream.value(const []);

  @override
  Future<String> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) => throw UnimplementedError(_unconfiguredMessage);

  @override
  Future<void> setDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) => throw UnimplementedError(_unconfiguredMessage);

  @override
  Future<void> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) => throw UnimplementedError(_unconfiguredMessage);
}
