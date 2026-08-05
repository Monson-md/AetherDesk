import 'package:aetherdesk/core/services/firebase/models/remote_file.dart';
import 'package:aetherdesk/core/services/firebase/storage/firebase_storage_repository.dart';
import 'package:aetherdesk/core/services/firebase/storage/firebase_storage_service.dart';

class FirebaseStorageRepositoryImpl implements FirebaseStorageRepository {
  const FirebaseStorageRepositoryImpl(this._service);
  final FirebaseStorageService _service;

  @override
  Future<RemoteFile> upload(
    String storagePath,
    List<int> bytes, {
    String? contentType,
  }) => _service.uploadBytes(
    storagePath: storagePath,
    bytes: bytes,
    contentType: contentType,
  );

  @override
  Future<String> downloadUrlFor(String storagePath) =>
      _service.getDownloadUrl(storagePath);

  @override
  Future<void> delete(String storagePath) => _service.deleteFile(storagePath);

  @override
  Stream<double> watchUploadProgress(String storagePath) =>
      _service.uploadProgress(storagePath);
}
