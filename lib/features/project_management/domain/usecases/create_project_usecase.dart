import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/entities/task_priority.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class CreateProjectUseCase {
  const CreateProjectUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call({
    required String name,
    String? description,
    String? categoryId,
    String? folderId,
    required TaskPriority priority,
    List<String> tags = const [],
    DateTime? dueDate,
  }) => _repository.createProject(
    name: name,
    description: description,
    categoryId: categoryId,
    folderId: folderId,
    priority: priority,
    tags: tags,
    dueDate: dueDate,
  );
}
