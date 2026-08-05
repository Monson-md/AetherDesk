import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_status.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class SetTaskStatusUseCase {
  const SetTaskStatusUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call(String projectId, String taskId, {required TaskStatus status}) =>
      _repository.setTaskStatus(projectId, taskId, status: status);
}
