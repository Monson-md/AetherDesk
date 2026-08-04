import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class SetTaskDoneUseCase {
  const SetTaskDoneUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call(String projectId, String taskId, {required bool isDone}) =>
      _repository.setTaskDone(projectId, taskId, isDone: isDone);
}
