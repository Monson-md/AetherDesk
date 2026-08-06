import 'package:aetherdesk/core/services/firebase/firestore/firestore_service.dart';
import 'package:aetherdesk/core/services/firebase/models/firestore_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;

/// Real [FirestoreService] backed by `cloud_firestore`.
class RealFirestoreService implements FirestoreService {
  RealFirestoreService({fs.FirebaseFirestore? firestore})
    : _firestore = firestore ?? fs.FirebaseFirestore.instance;

  final fs.FirebaseFirestore _firestore;

  FirestoreDocument? _toDocument(
    fs.DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    if (!snapshot.exists) return null;
    return FirestoreDocument(
      id: snapshot.id,
      collectionPath: snapshot.reference.parent.path,
      data: snapshot.data() ?? const {},
    );
  }

  @override
  Future<FirestoreDocument?> getDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    final snapshot = await _firestore
        .collection(collectionPath)
        .doc(documentId)
        .get();
    return _toDocument(snapshot);
  }

  @override
  Stream<FirestoreDocument?> watchDocument({
    required String collectionPath,
    required String documentId,
  }) {
    return _firestore
        .collection(collectionPath)
        .doc(documentId)
        .snapshots()
        .map(_toDocument);
  }

  @override
  Future<List<FirestoreDocument>> getCollection({
    required String collectionPath,
  }) async {
    final snapshot = await _firestore.collection(collectionPath).get();
    return snapshot.docs
        .map(
          (doc) => FirestoreDocument(
            id: doc.id,
            collectionPath: collectionPath,
            data: doc.data(),
          ),
        )
        .toList();
  }

  @override
  Stream<List<FirestoreDocument>> watchCollection({
    required String collectionPath,
  }) {
    return _firestore
        .collection(collectionPath)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => FirestoreDocument(
                  id: doc.id,
                  collectionPath: collectionPath,
                  data: doc.data(),
                ),
              )
              .toList(),
        );
  }

  @override
  Future<String> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    final ref = await _firestore.collection(collectionPath).add(data);
    return ref.id;
  }

  @override
  Future<void> setDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    bool merge = false,
  }) {
    return _firestore
        .collection(collectionPath)
        .doc(documentId)
        .set(data, merge ? fs.SetOptions(merge: true) : null);
  }

  @override
  Future<void> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) {
    return _firestore.collection(collectionPath).doc(documentId).delete();
  }
}
