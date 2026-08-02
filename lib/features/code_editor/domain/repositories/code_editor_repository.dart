import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/core/services/code_editor/code_token.dart';

/// Module-level contract for turning source code into highlighted tokens.
abstract interface class CodeEditorRepository {
  List<CodeToken> highlightCode({
    required String code,
    required CodeLanguage language,
  });
}
