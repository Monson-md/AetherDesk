import 'package:aetherdesk/core/services/firebase/models/remote_file.dart';
import 'package:aetherdesk/core/services/firebase/storage/firebase_storage_service.dart';

/// Default [FirebaseStorageService] wired in today — see
/// `NotConfiguredFirebaseAuthService`'s doc comment for the same rationale.
class NotConfiguredFirebaseStorageService implements FirebaseStorageService {
  const NotConfiguredFirebaseStorageService();

  static const _unconfiguredMessage =
      'Firebase Cloud Storage is not configured yet — see '
      'core/services/firebase/firebase_service.dart for activation steps.';

  @override
  Future<RemoteFile> uploadBytes({
    required String storagePath,
    required List<int> bytes,
    String? contentType,
  }) => throw UnimplementedError(_unconfiguredMessage);

  @override
  Future<String> getDownloadUrl(String storagePath) =>
      throw UnimplementedError(_unconfiguredMessage);

  @override
  Future<void> deleteFile(String storagePath) =>
      throw UnimplementedError(_unconfiguredMessage);

  @override
  Stream<double> uploadProgress(String storagePath) => const Stream.empty();
}
