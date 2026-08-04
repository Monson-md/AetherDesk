import 'package:aetherdesk/features/project_management/data/repositories/project_management_repository_impl.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/add_checklist_item_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/add_task_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/create_category_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/create_project_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/delete_category_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/delete_checklist_item_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/delete_project_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/delete_task_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/set_checklist_item_done_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/set_project_favorite_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/set_task_done_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/update_project_details_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/update_task_details_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final projectManagementRepositoryProvider =
    Provider<ProjectManagementRepository>((ref) {
      return ProjectManagementRepositoryImpl();
    });

final createProjectUseCaseProvider = Provider<CreateProjectUseCase>((ref) {
  return CreateProjectUseCase(ref.watch(projectManagementRepositoryProvider));
});

final updateProjectDetailsUseCaseProvider =
    Provider<UpdateProjectDetailsUseCase>((ref) {
      return UpdateProjectDetailsUseCase(
        ref.watch(projectManagementRepositoryProvider),
      );
    });

final setProjectFavoriteUseCaseProvider = Provider<SetProjectFavoriteUseCase>((
  ref,
) {
  return SetProjectFavoriteUseCase(
    ref.watch(projectManagementRepositoryProvider),
  );
});

final deleteProjectUseCaseProvider = Provider<DeleteProjectUseCase>((ref) {
  return DeleteProjectUseCase(ref.watch(projectManagementRepositoryProvider));
});

final addTaskUseCaseProvider = Provider<AddTaskUseCase>((ref) {
  return AddTaskUseCase(ref.watch(projectManagementRepositoryProvider));
});

final updateTaskDetailsUseCaseProvider = Provider<UpdateTaskDetailsUseCase>((
  ref,
) {
  return UpdateTaskDetailsUseCase(
    ref.watch(projectManagementRepositoryProvider),
  );
});

final setTaskDoneUseCaseProvider = Provider<SetTaskDoneUseCase>((ref) {
  return SetTaskDoneUseCase(ref.watch(projectManagementRepositoryProvider));
});

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) {
  return DeleteTaskUseCase(ref.watch(projectManagementRepositoryProvider));
});

final addChecklistItemUseCaseProvider = Provider<AddChecklistItemUseCase>((
  ref,
) {
  return AddChecklistItemUseCase(
    ref.watch(projectManagementRepositoryProvider),
  );
});

final setChecklistItemDoneUseCaseProvider =
    Provider<SetChecklistItemDoneUseCase>((ref) {
      return SetChecklistItemDoneUseCase(
        ref.watch(projectManagementRepositoryProvider),
      );
    });

final deleteChecklistItemUseCaseProvider = Provider<DeleteChecklistItemUseCase>(
  (ref) {
    return DeleteChecklistItemUseCase(
      ref.watch(projectManagementRepositoryProvider),
    );
  },
);

final createCategoryUseCaseProvider = Provider<CreateCategoryUseCase>((ref) {
  return CreateCategoryUseCase(ref.watch(projectManagementRepositoryProvider));
});

final deleteCategoryUseCaseProvider = Provider<DeleteCategoryUseCase>((ref) {
  return DeleteCategoryUseCase(ref.watch(projectManagementRepositoryProvider));
});
