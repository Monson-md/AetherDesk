import 'package:aetherdesk/core/services/code_editor/simulated_syntax_highlighter.dart';
import 'package:aetherdesk/core/services/code_editor/syntax_highlighter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single place to swap the simulated highlighter for a real editing
/// engine later: change what this provider returns (or override it in a
/// `ProviderScope`) and every consumer — currently `features/code_editor` —
/// picks up the new implementation automatically.
final syntaxHighlighterProvider = Provider<SyntaxHighlighter>(
  (ref) => const SimulatedSyntaxHighlighter(),
);
