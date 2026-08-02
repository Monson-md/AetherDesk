/// Semantic category of a [CodeToken], independent of any color choice —
/// [SyntaxHighlighter] implementations decide the type, presentation code
/// decides the color.
enum CodeTokenType {
  keyword,
  string,
  comment,
  number,
  type,
  punctuation,
  plain,
}

/// A single slice of source code tagged with its [type], as produced by a
/// [SyntaxHighlighter]. A full highlighted line/document is a `List<CodeToken>`
/// whose `text` values concatenate back to the original source.
class CodeToken {
  const CodeToken({required this.text, required this.type});

  final String text;
  final CodeTokenType type;
}
