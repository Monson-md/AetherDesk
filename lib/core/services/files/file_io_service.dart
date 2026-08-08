/// A text file read from disk via [FileIoService.pickAndReadTextFile].
class PickedTextFile {
  const PickedTextFile({
    required this.fileName,
    required this.content,
    required this.path,
  });

  final String fileName;
  final String content;
  final String path;
}

/// The result of [FileIoService.saveTextFile].
class SavedTextFile {
  const SavedTextFile({required this.fileName, required this.path});

  final String fileName;
  final String path;
}

/// The result of [FileIoService.pickAndStoreImage]: a real, stable path
/// inside the app's own private storage, safe to read back later (unlike
/// the picker's own temporary/cache path, which platforms may reclaim).
class StoredImage {
  const StoredImage({required this.path});

  final String path;
}

/// Contract for real local file open/save dialogs, so `features/code_editor`
/// (and any future module) can read/write real files without depending on
/// `file_picker`/`dart:io` directly. This is the swap point: today's
/// implementation (`RealFileIoService`) already does real disk I/O — a
/// future implementation could add cloud-file support (e.g. Firebase
/// Storage/Google Drive) behind the same contract.
abstract interface class FileIoService {
  /// Opens a native file picker and reads the selected file as text.
  /// Returns `null` if the user cancels.
  Future<PickedTextFile?> pickAndReadTextFile();

  /// Opens a native save dialog pre-filled with [suggestedName] and writes
  /// [content] to the chosen location. Returns `null` if the user cancels.
  Future<SavedTextFile?> saveTextFile({
    required String suggestedName,
    required String content,
  });

  /// Opens a native save dialog pre-filled with [suggestedName] and writes
  /// raw [bytes] to the chosen location (e.g. an exported PNG). Returns
  /// `null` if the user cancels.
  Future<SavedTextFile?> saveBinaryFile({
    required String suggestedName,
    required List<int> bytes,
  });

  /// Opens a native image picker and copies the chosen image into this
  /// app's own private storage under [fileName] (overwriting any previous
  /// file with that name). Returns `null` if the user cancels.
  Future<StoredImage?> pickAndStoreImage({required String fileName});
}
