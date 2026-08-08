import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/core/services/code_editor/code_token.dart';

/// Contract for anything that can tokenize source code for syntax
/// highlighting. `RealSyntaxHighlighter` is the real implementation,
/// backed by the `flutter_highlighting`/`highlighting` package (the Dart
/// port of highlight.js) — swapping the engine later only means writing a
/// new [SyntaxHighlighter] and registering it in a Riverpod provider;
/// nothing in `domain/` or `presentation/` has to change.
abstract interface class SyntaxHighlighter {
  /// Tokenizes [code] according to [language]. Concatenating every
  /// [CodeToken.text] in order must reproduce [code] exactly, so the caller
  /// can render styled spans without losing any character.
  List<CodeToken> highlight({
    required String code,
    required CodeLanguage language,
  });
}
