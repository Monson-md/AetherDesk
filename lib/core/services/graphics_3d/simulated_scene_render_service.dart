import 'package:aetherdesk/core/services/graphics_3d/scene_render_service.dart';

/// Placeholder [SceneRenderService]: waits briefly to mimic real render
/// work, then returns a description of what *would* have been rendered.
/// Not a real 3D engine — just enough to let the UI exercise a full render
/// flow before one exists.
class SimulatedSceneRenderService implements SceneRenderService {
  const SimulatedSceneRenderService();

  static const _latency = Duration(milliseconds: 700);

  @override
  Future<String> renderPreview({
    required String sceneName,
    required int objectCount,
    required int lightCount,
  }) async {
    await Future<void>.delayed(_latency);
    return '$sceneName : aperçu simulé généré ($objectCount objets, '
        '$lightCount lumière(s)) — aucun moteur 3D réel connecté.';
  }
}
