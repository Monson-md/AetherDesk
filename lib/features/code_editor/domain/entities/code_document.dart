import 'package:aetherdesk/core/services/code_editor/code_language.dart';

/// The single in-memory document held by the code editor. [path] is the
/// real file system path once the document has been opened from or saved
/// to disk (via `FileIoService`); it stays `null` for a new, never-saved
/// document.
class CodeDocument {
  const CodeDocument({
    required this.fileName,
    required this.language,
    required this.content,
    this.path,
  });

  factory CodeDocument.untitled(CodeLanguage language) => CodeDocument(
    fileName: 'sans-titre.${language.fileExtension}',
    language: language,
    content: '',
  );

  final String fileName;
  final CodeLanguage language;
  final String content;
  final String? path;

  CodeDocument copyWith({
    String? fileName,
    CodeLanguage? language,
    String? content,
    String? path,
  }) {
    return CodeDocument(
      fileName: fileName ?? this.fileName,
      language: language ?? this.language,
      content: content ?? this.content,
      path: path ?? this.path,
    );
  }
}
