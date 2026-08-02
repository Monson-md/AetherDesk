/// Programming/markup languages selectable in the code editor module.
///
/// Kept in `core/services` (not a feature's `domain/`) because it is part of
/// the [SyntaxHighlighter] contract's signature, and highlighting is a
/// cross-cutting service any future module could reuse.
enum CodeLanguage { dart, python, cpp, javascript, html, css, json }

/// Display metadata for a [CodeLanguage]. Language names are proper nouns
/// and intentionally not localized.
extension CodeLanguageX on CodeLanguage {
  String get label => switch (this) {
    CodeLanguage.dart => 'Dart',
    CodeLanguage.python => 'Python',
    CodeLanguage.cpp => 'C++',
    CodeLanguage.javascript => 'JavaScript',
    CodeLanguage.html => 'HTML',
    CodeLanguage.css => 'CSS',
    CodeLanguage.json => 'JSON',
  };

  String get fileExtension => switch (this) {
    CodeLanguage.dart => 'dart',
    CodeLanguage.python => 'py',
    CodeLanguage.cpp => 'cpp',
    CodeLanguage.javascript => 'js',
    CodeLanguage.html => 'html',
    CodeLanguage.css => 'css',
    CodeLanguage.json => 'json',
  };
}
