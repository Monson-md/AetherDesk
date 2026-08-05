import 'package:aetherdesk/features/creation_3d/domain/entities/creation_3d_project.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/material_preset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_asset.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/scene_object.dart';
import 'package:aetherdesk/features/creation_3d/domain/entities/vector3.dart';
import 'package:aetherdesk/features/creation_3d/presentation/providers/creation_3d_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State of the 3D creation workspace: the current scene, its asset
/// catalog and which object is selected in the inspector.
class Creation3dState {
  const Creation3dState({
    required this.project,
    required this.assets,
    this.selectedObjectId,
    this.isRendering = false,
    this.lastPreviewMessage,
  });

  final Creation3dProject project;
  final List<SceneAsset> assets;
  final String? selectedObjectId;
  final bool isRendering;
  final String? lastPreviewMessage;

  SceneObject3d? get selectedObject {
    final id = selectedObjectId;
    if (id == null) return null;
    for (final object in project.objects) {
      if (object.id == id) return object;
    }
    return null;
  }

  Creation3dState copyWith({
    Creation3dProject? project,
    List<SceneAsset>? assets,
    String? selectedObjectId,
    bool? isRendering,
    String? lastPreviewMessage,
  }) {
    return Creation3dState(
      project: project ?? this.project,
      assets: assets ?? this.assets,
      selectedObjectId: selectedObjectId ?? this.selectedObjectId,
      isRendering: isRendering ?? this.isRendering,
      lastPreviewMessage: lastPreviewMessage ?? this.lastPreviewMessage,
    );
  }
}

/// Holds the 3D creation workspace state and wires user actions to the
/// `Creation3dRepository` usecases.
class Creation3dController extends Notifier<Creation3dState> {
  @override
  Creation3dState build() {
    final project = ref.read(creation3dRepositoryProvider).getProject();
    final assets = ref.read(getAssetLibraryUseCaseProvider).call();
    return Creation3dState(project: project, assets: assets);
  }

  void addObject(SceneAsset asset) {
    final project = ref.read(addSceneObjectUseCaseProvider).call(asset);
    state = state.copyWith(
      project: project,
      selectedObjectId: project.objects.last.id,
    );
  }

  void selectObject(String? objectId) {
    state = Creation3dState(
      project: state.project,
      assets: state.assets,
      selectedObjectId: objectId,
      isRendering: state.isRendering,
      lastPreviewMessage: state.lastPreviewMessage,
    );
  }

  void updateObject({
    required String objectId,
    String? name,
    Vector3? position,
    Vector3? rotation,
    Vector3? scale,
    int? colorValue,
    MaterialPreset? material,
    bool? isVisible,
    bool? isLocked,
    double? lightIntensity,
    double? cameraFov,
  }) {
    final project = ref
        .read(updateSceneObjectUseCaseProvider)
        .call(
          objectId: objectId,
          name: name,
          position: position,
          rotation: rotation,
          scale: scale,
          colorValue: colorValue,
          material: material,
          isVisible: isVisible,
          isLocked: isLocked,
          lightIntensity: lightIntensity,
          cameraFov: cameraFov,
        );
    state = state.copyWith(project: project);
  }

  void deleteObject(String objectId) {
    final project = ref.read(deleteSceneObjectUseCaseProvider).call(objectId);
    final stillSelected = state.selectedObjectId != objectId;
    state = Creation3dState(
      project: project,
      assets: state.assets,
      selectedObjectId: stillSelected ? state.selectedObjectId : null,
      isRendering: state.isRendering,
      lastPreviewMessage: state.lastPreviewMessage,
    );
  }

  void duplicateObject(String objectId) {
    final project = ref
        .read(duplicateSceneObjectUseCaseProvider)
        .call(objectId);
    state = state.copyWith(
      project: project,
      selectedObjectId: project.objects.last.id,
    );
  }

  Future<void> renderPreview() async {
    state = state.copyWith(isRendering: true);
    final message = await ref.read(renderScenePreviewUseCaseProvider).call();
    state = state.copyWith(isRendering: false, lastPreviewMessage: message);
  }

  /// Clears [Creation3dState.lastPreviewMessage] once the UI has shown it,
  /// so the same message doesn't reappear on the next rebuild.
  void acknowledgePreviewMessage() {
    state = Creation3dState(
      project: state.project,
      assets: state.assets,
      selectedObjectId: state.selectedObjectId,
      isRendering: state.isRendering,
    );
  }
}

final creation3dControllerProvider =
    NotifierProvider<Creation3dController, Creation3dState>(
      Creation3dController.new,
    );
