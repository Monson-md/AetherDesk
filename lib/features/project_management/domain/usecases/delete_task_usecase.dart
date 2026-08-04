import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class DeleteTaskUseCase {
  const DeleteTaskUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call(String projectId, String taskId) =>
      _repository.deleteTask(projectId, taskId);
}
