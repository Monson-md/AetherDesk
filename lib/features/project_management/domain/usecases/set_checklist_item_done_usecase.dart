import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class SetChecklistItemDoneUseCase {
  const SetChecklistItemDoneUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call(
    String projectId,
    String taskId,
    String itemId, {
    required bool isDone,
  }) => _repository.setChecklistItemDone(
    projectId,
    taskId,
    itemId,
    isDone: isDone,
  );
}
