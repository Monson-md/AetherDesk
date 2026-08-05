import 'package:aetherdesk/core/services/firebase/models/remote_file.dart';

/// Contract for Firebase Cloud Storage — deliberately named
/// `FirebaseStorageService` rather than `StorageService` to stay
/// unambiguous next to `core/services/storage/` (local device storage,
/// unrelated). Intentionally NOT implemented yet — no `firebase_storage`
/// dependency, no Firebase project configuration. See
/// `core/services/firebase/firebase_service.dart` for activation steps.
abstract interface class FirebaseStorageService {
  Future<RemoteFile> uploadBytes({
    required String storagePath,
    required List<int> bytes,
    String? contentType,
  });

  Future<String> getDownloadUrl(String storagePath);

  Future<void> deleteFile(String storagePath);

  Stream<double> uploadProgress(String storagePath);
}
