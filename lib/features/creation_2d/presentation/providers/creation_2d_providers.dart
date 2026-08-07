import 'package:aetherdesk/features/creation_2d/data/repositories/creation_2d_repository_impl.dart';
import 'package:aetherdesk/features/creation_2d/domain/repositories/creation_2d_repository.dart';
import 'package:aetherdesk/features/creation_2d/domain/usecases/add_canvas_element_usecase.dart';
import 'package:aetherdesk/features/creation_2d/domain/usecases/add_layer_usecase.dart';
import 'package:aetherdesk/features/creation_2d/domain/usecases/clear_layer_usecase.dart';
import 'package:aetherdesk/features/creation_2d/domain/usecases/delete_layer_usecase.dart';
import 'package:aetherdesk/features/creation_2d/domain/usecases/duplicate_layer_usecase.dart';
import 'package:aetherdesk/features/creation_2d/domain/usecases/reorder_layers_usecase.dart';
import 'package:aetherdesk/features/creation_2d/domain/usecases/undo_last_element_usecase.dart';
import 'package:aetherdesk/features/creation_2d/domain/usecases/update_layer_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final creation2dRepositoryProvider = Provider<Creation2dRepository>((ref) {
  return Creation2dRepositoryImpl();
});

final addCanvasElementUseCaseProvider = Provider<AddCanvasElementUseCase>((
  ref,
) {
  return AddCanvasElementUseCase(ref.watch(creation2dRepositoryProvider));
});

final undoLastElementUseCaseProvider = Provider<UndoLastElementUseCase>((ref) {
  return UndoLastElementUseCase(ref.watch(creation2dRepositoryProvider));
});

final addLayerUseCaseProvider = Provider<AddLayerUseCase>((ref) {
  return AddLayerUseCase(ref.watch(creation2dRepositoryProvider));
});

final updateLayerUseCaseProvider = Provider<UpdateLayerUseCase>((ref) {
  return UpdateLayerUseCase(ref.watch(creation2dRepositoryProvider));
});

final deleteLayerUseCaseProvider = Provider<DeleteLayerUseCase>((ref) {
  return DeleteLayerUseCase(ref.watch(creation2dRepositoryProvider));
});

final duplicateLayerUseCaseProvider = Provider<DuplicateLayerUseCase>((ref) {
  return DuplicateLayerUseCase(ref.watch(creation2dRepositoryProvider));
});

final reorderLayersUseCaseProvider = Provider<ReorderLayersUseCase>((ref) {
  return ReorderLayersUseCase(ref.watch(creation2dRepositoryProvider));
});

final clearLayerUseCaseProvider = Provider<ClearLayerUseCase>((ref) {
  return ClearLayerUseCase(ref.watch(creation2dRepositoryProvider));
});
