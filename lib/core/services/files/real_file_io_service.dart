import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aetherdesk/core/services/files/file_io_service.dart';
import 'package:file_picker/file_picker.dart';

/// Real [FileIoService] backed by `file_picker` (native open/save dialogs)
/// and `dart:io` (actual reads/writes on desktop platforms — on
/// Android/iOS the plugin itself writes the bytes via the platform's Storage
/// Access Framework/document picker when `bytes` is supplied to
/// `saveFile`).
class RealFileIoService implements FileIoService {
  const RealFileIoService();

  @override
  Future<PickedTextFile?> pickAndReadTextFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const [
        'dart',
        'py',
        'cpp',
        'cc',
        'h',
        'hpp',
        'js',
        'mjs',
        'html',
        'htm',
        'css',
        'json',
        'txt',
        'md',
      ],
    );
    final path = result?.files.single.path;
    if (path == null) return null;
    final content = await File(path).readAsString();
    return PickedTextFile(
      fileName: result!.files.single.name,
      content: content,
      path: path,
    );
  }

  @override
  Future<SavedTextFile?> saveTextFile({
    required String suggestedName,
    required String content,
  }) async {
    final bytes = Uint8List.fromList(utf8.encode(content));
    final path = await FilePicker.platform.saveFile(
      fileName: suggestedName,
      bytes: bytes,
    );
    if (path == null) return null;
    // On desktop, file_picker only returns the chosen path — it doesn't
    // write the file itself, unlike on Android/iOS where passing `bytes`
    // makes the plugin write through the platform's document picker.
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      await File(path).writeAsBytes(bytes);
    }
    final separatorIndex = path.lastIndexOf(RegExp(r'[\\/]'));
    final fileName = separatorIndex == -1
        ? path
        : path.substring(separatorIndex + 1);
    return SavedTextFile(fileName: fileName, path: path);
  }
}
