import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class DeleteChecklistItemUseCase {
  const DeleteChecklistItemUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call(String projectId, String taskId, String itemId) =>
      _repository.deleteChecklistItem(projectId, taskId, itemId);
}
