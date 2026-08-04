import 'package:aetherdesk/features/project_management/domain/entities/project_category.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class CreateCategoryUseCase {
  const CreateCategoryUseCase(this._repository);
  final ProjectManagementRepository _repository;

  ProjectCategory call({required String name, required int colorValue}) =>
      _repository.createCategory(name: name, colorValue: colorValue);
}
