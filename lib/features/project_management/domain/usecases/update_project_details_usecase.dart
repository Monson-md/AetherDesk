import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class UpdateProjectDetailsUseCase {
  const UpdateProjectDetailsUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call({
    required String projectId,
    required String name,
    String? description,
    String? categoryId,
    required TaskPriority priority,
    DateTime? dueDate,
  }) => _repository.updateProjectDetails(
    projectId: projectId,
    name: name,
    description: description,
    categoryId: categoryId,
    priority: priority,
    dueDate: dueDate,
  );
}
