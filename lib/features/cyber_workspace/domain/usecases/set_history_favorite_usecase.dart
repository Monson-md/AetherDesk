import 'package:aetherdesk/features/cyber_workspace/domain/entities/cyber_history_entry.dart';
import 'package:aetherdesk/features/cyber_workspace/domain/repositories/cyber_workspace_repository.dart';

class SetHistoryFavoriteUseCase {
  const SetHistoryFavoriteUseCase(this._repository);
  final CyberWorkspaceRepository _repository;

  CyberHistoryEntry call(String entryId, {required bool isFavorite}) =>
      _repository.setHistoryFavorite(entryId, isFavorite: isFavorite);
}
