import 'package:aetherdesk/features/cyber_workspace/domain/repositories/cyber_workspace_repository.dart';

class DeleteHistoryEntryUseCase {
  const DeleteHistoryEntryUseCase(this._repository);
  final CyberWorkspaceRepository _repository;

  void call(String entryId) => _repository.deleteHistoryEntry(entryId);
}
