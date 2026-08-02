import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/core/services/code_editor/code_token.dart';

/// Contract for anything that can tokenize source code for syntax
/// highlighting, from the current keyword-based simulation up to a real
/// parser or language server later.
///
/// Defining this now — with zero real implementation — lets
/// `features/code_editor` build against a stable abstraction. Swapping the
/// engine later only means writing a new [SyntaxHighlighter] and registering
/// it in a Riverpod provider; nothing in `domain/` or `presentation/` has to
/// change.
abstract interface class SyntaxHighlighter {
  /// Tokenizes [code] according to [language]. Concatenating every
  /// [CodeToken.text] in order must reproduce [code] exactly, so the caller
  /// can render styled spans without losing any character.
  List<CodeToken> highlight({
    required String code,
    required CodeLanguage language,
  });
}
