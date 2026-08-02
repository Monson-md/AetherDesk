import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/features/code_editor/domain/entities/code_document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the single open [CodeDocument]. There is no persistence yet — every
/// action mutates in-memory state only, ready to be backed by real file I/O
/// later without changing the public API of this controller.
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
}

final codeEditorControllerProvider =
    NotifierProvider<CodeEditorController, CodeDocument>(
      CodeEditorController.new,
    );
