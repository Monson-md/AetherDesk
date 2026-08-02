import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/core/services/code_editor/code_token.dart';
import 'package:flutter/material.dart';

typedef CodeTokenizer =
    List<CodeToken> Function({
      required String code,
      required CodeLanguage language,
    });

typedef CodeTokenColorResolver = Color Function(CodeTokenType type);

/// A [TextEditingController] that renders itself as highlighted code by
/// overriding [buildTextSpan], while all editing/selection/IME behavior
/// stays exactly what a plain `TextField` provides — no custom input
/// handling needed.
class HighlightingTextEditingController extends TextEditingController {
  HighlightingTextEditingController({
    required this.tokenize,
    required this.colorForType,
    required CodeLanguage language,
    super.text,
    // Public API name (`language`) intentionally differs from the private
    // backing field (`_language`), so an initializing formal can't be used.
    // ignore: prefer_initializing_formals
  }) : _language = language;

  final CodeTokenizer tokenize;
  final CodeTokenColorResolver colorForType;
  CodeLanguage _language;

  CodeLanguage get language => _language;

  set language(CodeLanguage value) {
    if (value == _language) return;
    _language = value;
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final tokens = tokenize(code: text, language: _language);
    return TextSpan(
      style: style,
      children: [
        for (final token in tokens)
          TextSpan(
            text: token.text,
            style: TextStyle(color: colorForType(token.type)),
          ),
      ],
    );
  }
}
