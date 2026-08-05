import 'package:aetherdesk/core/services/firebase/firestore/firestore_repository.dart';
import 'package:aetherdesk/core/services/firebase/firestore/firestore_service.dart';
import 'package:aetherdesk/core/services/firebase/models/firestore_document.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  const FirestoreRepositoryImpl(this._service);
  final FirestoreService _service;

  @override
  Future<FirestoreDocument?> fetchDocument(
    String collectionPath,
    String documentId,
  ) => _service.getDocument(
    collectionPath: collectionPath,
    documentId: documentId,
  );

  @override
  Stream<FirestoreDocument?> watchDocument(
    String collectionPath,
    String documentId,
  ) => _service.watchDocument(
    collectionPath: collectionPath,
    documentId: documentId,
  );

  @override
  Future<List<FirestoreDocument>> fetchCollection(String collectionPath) =>
      _service.getCollection(collectionPath: collectionPath);

  @override
  Stream<List<FirestoreDocument>> watchCollection(String collectionPath) =>
      _service.watchCollection(collectionPath: collectionPath);

  @override
  Future<String> create(String collectionPath, Map<String, dynamic> data) =>
      _service.addDocument(collectionPath: collectionPath, data: data);

  @override
  Future<void> save(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data, {
    bool merge = false,
  }) => _service.setDocument(
    collectionPath: collectionPath,
    documentId: documentId,
    data: data,
    merge: merge,
  );

  @override
  Future<void> remove(String collectionPath, String documentId) => _service
      .deleteDocument(collectionPath: collectionPath, documentId: documentId);
}
