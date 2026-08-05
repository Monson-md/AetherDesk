import 'package:aetherdesk/core/services/graphics_3d/scene_render_service.dart';
import 'package:aetherdesk/core/services/graphics_3d/simulated_scene_render_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single place to swap the simulated renderer for a real 3D engine
/// later: change what this provider returns (or override it in a
/// `ProviderScope`) and every consumer — currently `features/creation_3d` —
/// picks up the new implementation automatically.
final sceneRenderServiceProvider = Provider<SceneRenderService>(
  (ref) => const SimulatedSceneRenderService(),
);
