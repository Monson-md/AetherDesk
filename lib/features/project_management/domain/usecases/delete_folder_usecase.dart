import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class DeleteFolderUseCase {
  const DeleteFolderUseCase(this._repository);
  final ProjectManagementRepository _repository;

  void call(String folderId) => _repository.deleteFolder(folderId);
}
