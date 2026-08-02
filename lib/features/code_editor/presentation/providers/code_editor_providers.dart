import 'package:aetherdesk/core/services/code_editor/syntax_highlighter_provider.dart';
import 'package:aetherdesk/features/code_editor/data/repositories/code_editor_repository_impl.dart';
import 'package:aetherdesk/features/code_editor/domain/repositories/code_editor_repository.dart';
import 'package:aetherdesk/features/code_editor/domain/usecases/highlight_code_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final codeEditorRepositoryProvider = Provider<CodeEditorRepository>((ref) {
  return CodeEditorRepositoryImpl(ref.watch(syntaxHighlighterProvider));
});

final highlightCodeUseCaseProvider = Provider<HighlightCodeUseCase>((ref) {
  return HighlightCodeUseCase(ref.watch(codeEditorRepositoryProvider));
});
