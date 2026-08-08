import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/core/services/code_editor/code_token.dart';
import 'package:aetherdesk/core/services/code_editor/syntax_highlighter.dart';
import 'package:aetherdesk/features/code_editor/domain/repositories/code_editor_repository.dart';

/// Adapts the module's [CodeEditorRepository] contract onto the app-wide
/// [SyntaxHighlighter] (`RealSyntaxHighlighter`, backed by
/// `flutter_highlighting`). This is the seam: swap what
/// `syntaxHighlighterProvider` resolves to and this class — and everything
/// above it — stays exactly the same.
class CodeEditorRepositoryImpl implements CodeEditorRepository {
  const CodeEditorRepositoryImpl(this._highlighter);

  final SyntaxHighlighter _highlighter;

  @override
  List<CodeToken> highlightCode({
    required String code,
    required CodeLanguage language,
  }) => _highlighter.highlight(code: code, language: language);
}
