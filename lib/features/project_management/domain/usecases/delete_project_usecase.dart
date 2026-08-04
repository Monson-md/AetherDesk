import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class DeleteProjectUseCase {
  const DeleteProjectUseCase(this._repository);
  final ProjectManagementRepository _repository;

  void call(String projectId) => _repository.deleteProject(projectId);
}
