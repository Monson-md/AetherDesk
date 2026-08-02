import 'package:aetherdesk/core/services/code_editor/code_language.dart';
import 'package:aetherdesk/core/services/code_editor/code_token.dart';
import 'package:aetherdesk/features/code_editor/domain/repositories/code_editor_repository.dart';

class HighlightCodeUseCase {
  const HighlightCodeUseCase(this._repository);

  final CodeEditorRepository _repository;

  List<CodeToken> call({
    required String code,
    required CodeLanguage language,
  }) => _repository.highlightCode(code: code, language: language);
}
