import 'package:aetherdesk/features/cyber_workspace/domain/repositories/cyber_workspace_repository.dart';

class RunTerminalCommandUseCase {
  const RunTerminalCommandUseCase(this._repository);
  final CyberWorkspaceRepository _repository;

  Future<String> call(String command) => _repository.runCommand(command);
}
