import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class AddChecklistItemUseCase {
  const AddChecklistItemUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call({
    required String projectId,
    required String taskId,
    required String label,
  }) => _repository.addChecklistItem(
    projectId: projectId,
    taskId: taskId,
    label: label,
  );
}
