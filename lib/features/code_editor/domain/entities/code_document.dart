import 'package:aetherdesk/core/services/code_editor/code_language.dart';

/// The single in-memory document held by the code editor. There is no file
/// system behind it yet — `fileName` is a display label, not a path.
class CodeDocument {
  const CodeDocument({
    required this.fileName,
    required this.language,
    required this.content,
  });

  factory CodeDocument.untitled(CodeLanguage language) => CodeDocument(
    fileName: 'sans-titre.${language.fileExtension}',
    language: language,
    content: '',
  );

  final String fileName;
  final CodeLanguage language;
  final String content;

  CodeDocument copyWith({
    String? fileName,
    CodeLanguage? language,
    String? content,
  }) {
    return CodeDocument(
      fileName: fileName ?? this.fileName,
      language: language ?? this.language,
      content: content ?? this.content,
    );
  }
}
