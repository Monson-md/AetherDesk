import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/core/services/code_editor/code_token.dart';
import 'package:aetherdesk/core/services/code_editor/syntax_highlighter.dart';

/// Local, fully offline stand-in for [SyntaxHighlighter].
///
/// Uses a hand-rolled, single-pass tokenizer driven by a per-language
/// keyword/comment/string spec — a simulation, not a real grammar-aware
/// parser, which is all the editor needs today. Swapping this for a real
/// engine later means changing what `syntaxHighlighterProvider` resolves to;
/// nothing above [SyntaxHighlighter] needs to change.
class SimulatedSyntaxHighlighter implements SyntaxHighlighter {
  const SimulatedSyntaxHighlighter();

  @override
  List<CodeToken> highlight({
    required String code,
    required CodeLanguage language,
  }) {
    if (code.isEmpty) return const [];
    return _tokenize(code, _specFor(language));
  }

  List<CodeToken> _tokenize(String code, _LanguageSpec spec) {
    final tokens = <CodeToken>[];
    final buffer = StringBuffer();
    var i = 0;

    void flushPunctuation() {
      if (buffer.isEmpty) return;
      tokens.add(
        CodeToken(text: buffer.toString(), type: CodeTokenType.punctuation),
      );
      buffer.clear();
    }

    while (i < code.length) {
      final blockStart = spec.blockCommentStart;
      final blockEnd = spec.blockCommentEnd;
      if (blockStart != null &&
          blockEnd != null &&
          code.startsWith(blockStart, i)) {
        flushPunctuation();
        final end = code.indexOf(blockEnd, i + blockStart.length);
        final stop = end == -1 ? code.length : end + blockEnd.length;
        tokens.add(
          CodeToken(text: code.substring(i, stop), type: CodeTokenType.comment),
        );
        i = stop;
        continue;
      }

      final lineComment = spec.lineComment;
      if (lineComment != null && code.startsWith(lineComment, i)) {
        flushPunctuation();
        final end = code.indexOf('\n', i);
        final stop = end == -1 ? code.length : end;
        tokens.add(
          CodeToken(text: code.substring(i, stop), type: CodeTokenType.comment),
        );
        i = stop;
        continue;
      }

      final char = code[i];

      if (spec.stringQuotes.contains(char)) {
        flushPunctuation();
        final start = i;
        i++;
        while (i < code.length && code[i] != char) {
          if (code[i] == r'\' && i + 1 < code.length) {
            i += 2;
          } else {
            i++;
          }
        }
        if (i < code.length) i++;
        tokens.add(
          CodeToken(text: code.substring(start, i), type: CodeTokenType.string),
        );
        continue;
      }

      if (_isDigit(char)) {
        flushPunctuation();
        final start = i;
        while (i < code.length && (_isDigit(code[i]) || code[i] == '.')) {
          i++;
        }
        tokens.add(
          CodeToken(text: code.substring(start, i), type: CodeTokenType.number),
        );
        continue;
      }

      if (_isWordStart(char)) {
        flushPunctuation();
        final start = i;
        while (i < code.length && _isWordChar(code[i])) {
          i++;
        }
        final word = code.substring(start, i);
        final type = spec.keywords.contains(word)
            ? CodeTokenType.keyword
            : spec.types.contains(word)
            ? CodeTokenType.type
            : CodeTokenType.plain;
        tokens.add(CodeToken(text: word, type: type));
        continue;
      }

      buffer.write(char);
      i++;
    }

    flushPunctuation();
    return tokens;
  }

  bool _isDigit(String char) => RegExp(r'^[0-9]$').hasMatch(char);

  bool _isWordStart(String char) => RegExp(r'^[A-Za-z_@#]$').hasMatch(char);

  bool _isWordChar(String char) => RegExp(r'^[A-Za-z0-9_-]$').hasMatch(char);

  _LanguageSpec _specFor(CodeLanguage language) {
    switch (language) {
      case CodeLanguage.dart:
        return const _LanguageSpec(
          keywords: {
            'abstract',
            'as',
            'assert',
            'async',
            'await',
            'break',
            'case',
            'catch',
            'class',
            'const',
            'continue',
            'default',
            'do',
            'else',
            'enum',
            'extends',
            'extension',
            'final',
            'finally',
            'for',
            'if',
            'implements',
            'import',
            'in',
            'interface',
            'is',
            'late',
            'library',
            'mixin',
            'new',
            'null',
            'return',
            'static',
            'super',
            'switch',
            'this',
            'throw',
            'true',
            'false',
            'try',
            'typedef',
            'var',
            'void',
            'while',
            'with',
            'yield',
          },
          types: {
            'int',
            'double',
            'num',
            'bool',
            'String',
            'List',
            'Map',
            'Set',
            'Future',
            'Stream',
            'Object',
            'dynamic',
          },
          lineComment: '//',
          blockCommentStart: '/*',
          blockCommentEnd: '*/',
          stringQuotes: {'"', "'"},
        );
      case CodeLanguage.python:
        return const _LanguageSpec(
          keywords: {
            'and',
            'as',
            'assert',
            'async',
            'await',
            'break',
            'class',
            'continue',
            'def',
            'del',
            'elif',
            'else',
            'except',
            'False',
            'finally',
            'for',
            'from',
            'global',
            'if',
            'import',
            'in',
            'is',
            'lambda',
            'None',
            'nonlocal',
            'not',
            'or',
            'pass',
            'raise',
            'return',
            'True',
            'try',
            'while',
            'with',
            'yield',
            'self',
          },
          types: {
            'int',
            'float',
            'str',
            'bool',
            'list',
            'dict',
            'set',
            'tuple',
          },
          lineComment: '#',
          stringQuotes: {'"', "'"},
        );
      case CodeLanguage.cpp:
        return const _LanguageSpec(
          keywords: {
            'break',
            'case',
            'catch',
            'class',
            'const',
            'continue',
            'default',
            'delete',
            'do',
            'else',
            'enum',
            'explicit',
            'export',
            'extern',
            'false',
            'for',
            'friend',
            'goto',
            'if',
            'inline',
            'namespace',
            'new',
            'nullptr',
            'operator',
            'private',
            'protected',
            'public',
            'return',
            'sizeof',
            'static',
            'struct',
            'switch',
            'template',
            'this',
            'throw',
            'true',
            'try',
            'typedef',
            'typename',
            'union',
            'using',
            'virtual',
            'while',
          },
          types: {
            'int',
            'float',
            'double',
            'char',
            'bool',
            'void',
            'long',
            'short',
            'unsigned',
            'signed',
            'auto',
            'string',
            'vector',
            'map',
          },
          lineComment: '//',
          blockCommentStart: '/*',
          blockCommentEnd: '*/',
          stringQuotes: {'"', "'"},
        );
      case CodeLanguage.javascript:
        return const _LanguageSpec(
          keywords: {
            'async',
            'await',
            'break',
            'case',
            'catch',
            'class',
            'const',
            'continue',
            'default',
            'delete',
            'do',
            'else',
            'export',
            'extends',
            'false',
            'finally',
            'for',
            'function',
            'if',
            'import',
            'in',
            'instanceof',
            'let',
            'new',
            'null',
            'return',
            'static',
            'super',
            'switch',
            'this',
            'throw',
            'true',
            'try',
            'typeof',
            'undefined',
            'var',
            'void',
            'while',
            'with',
            'yield',
          },
          types: {
            'Array',
            'Object',
            'String',
            'Number',
            'Boolean',
            'Promise',
            'Map',
            'Set',
          },
          lineComment: '//',
          blockCommentStart: '/*',
          blockCommentEnd: '*/',
          stringQuotes: {'"', "'", '`'},
        );
      case CodeLanguage.html:
        return const _LanguageSpec(
          keywords: {
            'html',
            'head',
            'body',
            'div',
            'span',
            'p',
            'a',
            'ul',
            'ol',
            'li',
            'h1',
            'h2',
            'h3',
            'h4',
            'h5',
            'h6',
            'script',
            'style',
            'title',
            'button',
            'input',
            'form',
            'table',
            'tr',
            'td',
            'th',
            'section',
            'header',
            'footer',
            'nav',
            'img',
            'link',
            'meta',
            'label',
          },
          types: {
            'class',
            'id',
            'href',
            'src',
            'type',
            'name',
            'style',
            'alt',
            'rel',
          },
          blockCommentStart: '<!--',
          blockCommentEnd: '-->',
          stringQuotes: {'"', "'"},
        );
      case CodeLanguage.css:
        return const _LanguageSpec(
          keywords: {
            'flex',
            'grid',
            'block',
            'inline',
            'none',
            'absolute',
            'relative',
            'fixed',
            'center',
            'bold',
            'solid',
            'dashed',
            'inherit',
            'important',
          },
          types: {
            'color',
            'background',
            'margin',
            'padding',
            'display',
            'position',
            'width',
            'height',
            'font-size',
            'font-weight',
            'border',
            'flex',
            'justify-content',
            'align-items',
            'gap',
            'top',
            'left',
            'right',
            'bottom',
          },
          blockCommentStart: '/*',
          blockCommentEnd: '*/',
          stringQuotes: {'"', "'"},
        );
      case CodeLanguage.json:
        return const _LanguageSpec(
          keywords: {'true', 'false', 'null'},
          stringQuotes: {'"'},
        );
    }
  }
}

/// Per-language tokenizing rules for [SimulatedSyntaxHighlighter].
class _LanguageSpec {
  const _LanguageSpec({
    required this.keywords,
    this.types = const {},
    this.lineComment,
    this.blockCommentStart,
    this.blockCommentEnd,
    required this.stringQuotes,
  });

  final Set<String> keywords;
  final Set<String> types;
  final String? lineComment;
  final String? blockCommentStart;
  final String? blockCommentEnd;
  final Set<String> stringQuotes;
}
