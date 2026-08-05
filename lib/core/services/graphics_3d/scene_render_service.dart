/// Contract for turning a 3D scene graph into a rendered preview, from
/// today's simulated placeholder up to a real 3D engine later.
///
/// Defining this now lets `features/creation_3d` build against a stable
/// abstraction. Swapping the engine later only means writing a new
/// [SceneRenderService] and registering it in a Riverpod provider; nothing
/// in `domain/` or `presentation/` has to change.
abstract interface class SceneRenderService {
  /// Returns a human-readable description of the render result. No real
  /// rasterization happens in the current implementation.
  Future<String> renderPreview({
    required String sceneName,
    required int objectCount,
    required int lightCount,
  });
}
