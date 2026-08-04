import 'package:aetherdesk/features/project_management/domain/entities/project.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';

class SetProjectFavoriteUseCase {
  const SetProjectFavoriteUseCase(this._repository);
  final ProjectManagementRepository _repository;

  Project call(String projectId, {required bool isFavorite}) =>
      _repository.setProjectFavorite(projectId, isFavorite: isFavorite);
}
