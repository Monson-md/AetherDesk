import 'package:aetherdesk/features/project_management/domain/entities/project_folder.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class RenameFolderUseCase {
  const RenameFolderUseCase(this._repository);
  final ProjectManagementRepository _repository;

  ProjectFolder call(String folderId, {required String name}) =>
      _repository.renameFolder(folderId, name: name);
}
