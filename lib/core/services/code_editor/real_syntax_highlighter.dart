import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/core/services/code_editor/code_token.dart';
import 'package:aetherdesk/core/services/code_editor/syntax_highlighter.dart';
import 'package:highlighting/highlighting.dart' as hljs;

/// Real [SyntaxHighlighter] backed by `flutter_highlighting`/`highlighting`
/// — the Dart port of highlight.js. This is the same grammar-driven engine
/// that powers highlight.js on the web, not a hand-rolled tokenizer: it
/// already understands string interpolation, triple-quoted strings, hex/
/// scientific numeric literals, doc comments, etc. per language, so none of
/// that needs to be reimplemented here — only the mapping from
/// highlight.js's scope names down to [CodeTokenType].
class RealSyntaxHighlighter implements SyntaxHighlighter {
  const RealSyntaxHighlighter();

  @override
  List<CodeToken> highlight({
    required String code,
    required CodeLanguage language,
  }) {
    if (code.isEmpty) return const [];
    try {
      final result = hljs.highlight.parse(
        code,
        languageId: _languageId(language),
      );
      final tokens = <CodeToken>[];
      for (final node in result.nodes ?? const []) {
        _collect(node, null, tokens);
      }
      return tokens;
    } on Exception {
      // A grammar edge case shouldn't ever break the editor — fall back to
      // rendering the whole buffer unstyled rather than losing text.
      return [CodeToken(text: code, type: CodeTokenType.plain)];
    }
  }

  void _collect(
    hljs.Node node,
    String? inheritedClassName,
    List<CodeToken> out,
  ) {
    final className = node.className ?? inheritedClassName;
    if (node.value != null) {
      if (node.value!.isEmpty) return;
      out.add(CodeToken(text: node.value!, type: _tokenType(className)));
      return;
    }
    for (final child in node.children) {
      _collect(child, className, out);
    }
  }

  CodeTokenType _tokenType(String? className) {
    if (className == null) return CodeTokenType.plain;
    // highlight.js scope names are sometimes dotted (e.g. "title.function",
    // "variable.language") — the first segment is enough to classify them.
    final scope = className.split('.').first;
    return switch (scope) {
      'comment' || 'doctag' => CodeTokenType.comment,
      'string' => CodeTokenType.string,
      // Dart's `$name`/`${expr}` and JS template-literal `${expr}`.
      'subst' => CodeTokenType.interpolation,
      'number' => CodeTokenType.number,
      'keyword' || 'literal' => CodeTokenType.keyword,
      'built_in' ||
      'type' ||
      'title' ||
      'function' ||
      'class' ||
      'tag' ||
      'name' ||
      'attr' ||
      'attribute' ||
      'property' => CodeTokenType.type,
      'punctuation' || 'symbol' => CodeTokenType.punctuation,
      _ => CodeTokenType.plain,
    };
  }

  String _languageId(CodeLanguage language) => switch (language) {
    CodeLanguage.dart => 'dart',
    CodeLanguage.python => 'python',
    CodeLanguage.cpp => 'cpp',
    CodeLanguage.javascript => 'javascript',
    // highlight.js's HTML grammar is registered under the "xml" id here;
    // "html" is only an alias on the Language's metadata, not a map key.
    CodeLanguage.html => 'xml',
    CodeLanguage.css => 'css',
    CodeLanguage.json => 'json',
  };
}
