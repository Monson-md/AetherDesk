import 'package:aetherdesk/core/services/firebase/models/remote_file.dart';

/// Feature-facing abstraction over [FirebaseStorageService] — see
/// `FirebaseAuthRepository`'s doc comment for the same rationale.
abstract interface class FirebaseStorageRepository {
  Future<RemoteFile> upload(
    String storagePath,
    List<int> bytes, {
    String? contentType,
  });

  Future<String> downloadUrlFor(String storagePath);

  Future<void> delete(String storagePath);

  Stream<double> watchUploadProgress(String storagePath);
}
