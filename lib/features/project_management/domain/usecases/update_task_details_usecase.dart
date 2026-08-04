import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class UpdateTaskDetailsUseCase {
  const UpdateTaskDetailsUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call({
    required String projectId,
    required String taskId,
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  }) => _repository.updateTaskDetails(
    projectId: projectId,
    taskId: taskId,
    title: title,
    description: description,
    priority: priority,
    dueDate: dueDate,
  );
}
