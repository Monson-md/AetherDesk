import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class DeleteCategoryUseCase {
  const DeleteCategoryUseCase(this._repository);
  final ProjectManagementRepository _repository;

  void call(String categoryId) => _repository.deleteCategory(categoryId);
}
