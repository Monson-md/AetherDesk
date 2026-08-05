/// Mirrors the subset of `firebase_storage`'s upload result / metadata that
/// call sites need, without depending on the `firebase_storage` package
/// (not added yet — see `firebase_service.dart`).
class RemoteFile {
  const RemoteFile({
    required this.storagePath,
    required this.downloadUrl,
    required this.sizeBytes,
    this.contentType,
  });

  final String storagePath;
  final String downloadUrl;
  final int sizeBytes;
  final String? contentType;
}
