import 'package:aetherdesk/features/cyber_workspace/domain/repositories/cyber_workspace_repository.dart';

class ClearHistoryUseCase {
  const ClearHistoryUseCase(this._repository);
  final CyberWorkspaceRepository _repository;

  void call() => _repository.clearHistory();
}
