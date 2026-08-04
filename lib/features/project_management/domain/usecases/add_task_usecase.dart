import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class AddTaskUseCase {
  const AddTaskUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call({
    required String projectId,
    required String title,
    String? description,
    required TaskPriority priority,
    DateTime? dueDate,
  }) => _repository.addTask(
    projectId: projectId,
    title: title,
    description: description,
    priority: priority,
    dueDate: dueDate,
  );
}
