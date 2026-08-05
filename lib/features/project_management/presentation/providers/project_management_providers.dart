import 'package:aetherdesk/features/project_management/data/repositories/project_management_repository_impl.dart';
import 'package:aetherdesk/features/project_management/domain/repositories/project_management_repository.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/add_checklist_item_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/add_task_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/create_category_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/create_folder_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/create_project_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/delete_category_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/delete_checklist_item_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/delete_folder_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/delete_project_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/delete_task_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/rename_folder_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/set_checklist_item_done_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/set_project_favorite_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/set_task_status_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/update_project_details_usecase.dart';
import 'package:aetherdesk/features/project_management/domain/usecases/update_task_details_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The persisted snapshot loaded in `main.dart` before the app's first
/// frame, or `null` on a fresh install. Overridden via `ProviderScope`'s
/// `overrides` — see `main.dart`.
final projectManagementSeedProvider = Provider<Map<String, dynamic>?>(
  (ref) => null,
);

final projectManagementRepositoryProvider =
    Provider<ProjectManagementRepository>((ref) {
      return ProjectManagementRepositoryImpl(
        seed: ref.watch(projectManagementSeedProvider),
      );
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

final setTaskStatusUseCaseProvider = Provider<SetTaskStatusUseCase>((ref) {
  return SetTaskStatusUseCase(ref.watch(projectManagementRepositoryProvider));
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

final createFolderUseCaseProvider = Provider<CreateFolderUseCase>((ref) {
  return CreateFolderUseCase(ref.watch(projectManagementRepositoryProvider));
});

final renameFolderUseCaseProvider = Provider<RenameFolderUseCase>((ref) {
  return RenameFolderUseCase(ref.watch(projectManagementRepositoryProvider));
});

final deleteFolderUseCaseProvider = Provider<DeleteFolderUseCase>((ref) {
  return DeleteFolderUseCase(ref.watch(projectManagementRepositoryProvider));
});
