import 'package:aetherdesk/core/services/graphics_3d/scene_render_service_provider.dart';
import 'package:aetherdesk/features/creation_3d/data/repositories/creation_3d_repository_impl.dart';
import 'package:aetherdesk/features/creation_3d/domain/repositories/creation_3d_repository.dart';
import 'package:aetherdesk/features/creation_3d/domain/usecases/add_scene_object_usecase.dart';
import 'package:aetherdesk/features/creation_3d/domain/usecases/delete_scene_object_usecase.dart';
import 'package:aetherdesk/features/creation_3d/domain/usecases/duplicate_scene_object_usecase.dart';
import 'package:aetherdesk/features/creation_3d/domain/usecases/get_asset_library_usecase.dart';
import 'package:aetherdesk/features/creation_3d/domain/usecases/render_scene_preview_usecase.dart';
import 'package:aetherdesk/features/creation_3d/domain/usecases/update_scene_object_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final creation3dRepositoryProvider = Provider<Creation3dRepository>((ref) {
  return Creation3dRepositoryImpl(ref.watch(sceneRenderServiceProvider));
});

final addSceneObjectUseCaseProvider = Provider<AddSceneObjectUseCase>((ref) {
  return AddSceneObjectUseCase(ref.watch(creation3dRepositoryProvider));
});

final updateSceneObjectUseCaseProvider = Provider<UpdateSceneObjectUseCase>((
  ref,
) {
  return UpdateSceneObjectUseCase(ref.watch(creation3dRepositoryProvider));
});

final deleteSceneObjectUseCaseProvider = Provider<DeleteSceneObjectUseCase>((
  ref,
) {
  return DeleteSceneObjectUseCase(ref.watch(creation3dRepositoryProvider));
});

final duplicateSceneObjectUseCaseProvider =
    Provider<DuplicateSceneObjectUseCase>((ref) {
      return DuplicateSceneObjectUseCase(
        ref.watch(creation3dRepositoryProvider),
      );
    });

final getAssetLibraryUseCaseProvider = Provider<GetAssetLibraryUseCase>((ref) {
  return GetAssetLibraryUseCase(ref.watch(creation3dRepositoryProvider));
});

final renderScenePreviewUseCaseProvider = Provider<RenderScenePreviewUseCase>((
  ref,
) {
  return RenderScenePreviewUseCase(ref.watch(creation3dRepositoryProvider));
});
