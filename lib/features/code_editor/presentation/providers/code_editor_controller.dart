import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/core/services/files/file_io_service_provider.dart';
import 'package:aetherdesk/features/code_editor/domain/entities/code_document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the single open [CodeDocument]. Content edits and language changes
/// are in-memory only; [openFile]/[saveFile] go through the real
/// `FileIoService` swap point for genuine disk I/O.
class CodeEditorController extends Notifier<CodeDocument> {
  @override
  CodeDocument build() => CodeDocument.untitled(CodeLanguage.dart);

  void updateContent(String content) {
    if (content == state.content) return;
    state = state.copyWith(content: content);
  }

  void changeLanguage(CodeLanguage language) {
    if (language == state.language) return;
    state = state.copyWith(language: language);
  }

  void newFile() {
    state = CodeDocument.untitled(state.language);
  }

  void clearContent() {
    state = state.copyWith(content: '');
  }

  /// Opens a native file picker and loads the selected file's real content.
  /// Returns whether a file was actually opened (`false` if cancelled).
  Future<bool> openFile() async {
    final picked = await ref.read(fileIoServiceProvider).pickAndReadTextFile();
    if (picked == null) return false;
    state = CodeDocument(
      fileName: picked.fileName,
      language: CodeLanguageX.fromFileName(picked.fileName),
      content: picked.content,
      path: picked.path,
    );
    return true;
  }

  /// Opens a native save dialog and writes the current content to disk.
  /// Returns whether the file was actually saved (`false` if cancelled).
  Future<bool> saveFile() async {
    final saved = await ref
        .read(fileIoServiceProvider)
        .saveTextFile(suggestedName: state.fileName, content: state.content);
    if (saved == null) return false;
    state = state.copyWith(fileName: saved.fileName, path: saved.path);
    return true;
  }
}

final codeEditorControllerProvider =
    NotifierProvider<CodeEditorController, CodeDocument>(
      CodeEditorController.new,
    );
