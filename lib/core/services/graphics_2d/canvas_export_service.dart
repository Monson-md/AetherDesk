/// Contract for turning a 2D canvas project into an exported artifact, from
/// today's simulated placeholder up to a real rasterizer/file writer later.
///
/// Defining this now lets `features/creation_2d` build against a stable
/// abstraction. Swapping the engine later only means writing a new
/// [CanvasExportService] and registering it in a Riverpod provider; nothing
/// in `domain/` or `presentation/` has to change.
abstract interface class CanvasExportService {
  /// Returns a human-readable description of the export result. No file is
  /// actually written to disk by the current implementation.
  Future<String> exportProject({
    required String projectName,
    required int layerCount,
    required int elementCount,
  });
}
