import 'package:aetherdesk/features/project_management/domain/entities/project_folder.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class CreateFolderUseCase {
  const CreateFolderUseCase(this._repository);
  final ProjectManagementRepository _repository;

  ProjectFolder call({required String name, String? parentId}) =>
      _repository.createFolder(name: name, parentId: parentId);
}
